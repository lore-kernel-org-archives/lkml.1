Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbXCDPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbXCDPL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 10:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXCDPL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 10:11:58 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:56427 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXCDPL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 10:11:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=q3Jm2zbZNxSHZWkUGng9BVVnkNrSSCsLYgygVXCGSyp3w3pa0E8JjawqA4MoahiQAJTonU6eeNyuDbQWhFYuz6p//PYypuIyziUGQtyah0epd/F6sRVJb+DaXrDebH+PvqlUIYK1QHgC+Z2oEfycv38q1b49mpPeBqrRKEO+24w=
Message-ID: <45EAE1B0.2020201@gmail.com>
Date: Sun, 04 Mar 2007 16:11:44 +0100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [Re: 2.6.21-rc2-mm1] #error no ROMFS backing store interface
 configured
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>	<20070302030405.22f78999.akpm@linux-foundation.org>	<45EAB46F.1030709@gmail.com> <20070304041111.1d2774e7.akpm@linux-foundation.org>
In-Reply-To: <20070304041111.1d2774e7.akpm@linux-foundation.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080206090207010600000807"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080206090207010600000807
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton napisa=C5=82(a):

>=20
> +config ROMFS_ON_BLOCK
> +	bool "Block device-backed ROM file system support"
> +	depends on ROMFS_FS && BLOCK
> +	help
> +	  This permits ROMFS to use block devices buffered through the page
> +	  cache as the medium from which to retrieve data.  It does not allow=

> +	  direct mapping of the medium.
> +
> +	  If unsure, answer Y.
> +
> +config ROMFS_ON_MTD
> +	bool "MTD-backed ROM file system support"
> +	depends on ROMFS_FS && MTD
> +	help
> +	  This permits ROMFS to use MTD based devices directly, without the
> +	  intercession of the block layer (which may have been disabled).  It=

> +	  also allows direct mapping of MTD devices through romfs files under=

> +	  NOMMU conditions if the underlying device is directly addressable b=
y
> +	  the CPU.
> +
>=20
> So we require that one of these be enabled if ROMFS.
>=20
> There's a way of doing that, but I forget what it is.  iirc Adrian has =
done
> this in the past and can perhaps point us at an example?
>=20

Yes, I change

# CONFIG_ROMFS_ON_BLOCK is not set

to

CONFIG_ROMFS_ON_BLOCK=3Dy

And error goes away.

Thanks

I dont' have ROMFS_ON_MTD option in config.

--=20
Maciej Rutecki <maciej.rutecki@gmail.com>


--------------ms080206090207010600000807
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJHzCC
AuowggJToAMCAQICEE6xoJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyODEyMzAwNloX
DTA3MDgyODEyMzAwNlowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUG
CSqGSIb3DQEJARYYbWFjaWVqLnJ1dGVja2lAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAxmrZ/vMNBQsTG+9oNg9WeFTNtluscxhg5oBwudmsZhsoDdtQYPlK
ZsRSZnkKTdEWR9w8dwi0JBxmq1XHumBA6/rFfAfhbOV1SBH3ktZ9foamMjpJTjO3+3gF9ocT
wj1GzfReeGZuPgr4qVVvOT5FfD/PkAJzvur7fyLnviiZokQz8R3c+VhJlW3HurhlOlK0ItUu
UuVtCdJosQRepYdPQ6H3Mvn74UxVttDeVxWNlQ2DaS7cy8wTmtc5CTNMVctbJkzFz0a/7wCJ
JHdmqKTgjMBm+ry/IC50jvwkLKAumSJBLWhoIB+LxkJlMwgn69jc0KJkrdkpsUjPdo+zDgff
iQIDAQABozUwMzAjBgNVHREEHDAagRhtYWNpZWoucnV0ZWNraUBnbWFpbC5jb20wDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQC2O4xAuM7DplCDsgJuaMKz3uR25rq9ucMqVtCW
CAfCyORrFaxN8LFF9KcYx6M4AK1fQ36JVPtMER2VzGMF74gXgrFQ4A9tno6rKzi/QpzwWoPE
4I1hcOKz/YxOK0sRjSDR3p5s2XrKVxgUe+TEeJ6/y1iv52o41oYVmilsUovvHzCCAuowggJT
oAMCAQICEE6xoJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyODEyMzAwNloXDTA3MDgy
ODEyMzAwNlowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUGCSqGSIb3
DQEJARYYbWFjaWVqLnJ1dGVja2lAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxmrZ/vMNBQsTG+9oNg9WeFTNtluscxhg5oBwudmsZhsoDdtQYPlKZsRSZnkK
TdEWR9w8dwi0JBxmq1XHumBA6/rFfAfhbOV1SBH3ktZ9foamMjpJTjO3+3gF9ocTwj1GzfRe
eGZuPgr4qVVvOT5FfD/PkAJzvur7fyLnviiZokQz8R3c+VhJlW3HurhlOlK0ItUuUuVtCdJo
sQRepYdPQ6H3Mvn74UxVttDeVxWNlQ2DaS7cy8wTmtc5CTNMVctbJkzFz0a/7wCJJHdmqKTg
jMBm+ry/IC50jvwkLKAumSJBLWhoIB+LxkJlMwgn69jc0KJkrdkpsUjPdo+zDgffiQIDAQAB
ozUwMzAjBgNVHREEHDAagRhtYWNpZWoucnV0ZWNraUBnbWFpbC5jb20wDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQUFAAOBgQC2O4xAuM7DplCDsgJuaMKz3uR25rq9ucMqVtCWCAfCyORr
FaxN8LFF9KcYx6M4AK1fQ36JVPtMER2VzGMF74gXgrFQ4A9tno6rKzi/QpzwWoPE4I1hcOKz
/YxOK0sRjSDR3p5s2XrKVxgUe+TEeJ6/y1iv52o41oYVmilsUovvHzCCAz8wggKooAMCAQIC
AQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENh
cGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAm
BgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1h
aWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNV
BAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQD
EyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEF
AAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B
1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79A
gAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8E
CDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3
dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEa
MBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7M
DaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUa
C4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk1
3iSx0x1G/11fZU8xggNkMIIDYAIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQQIQTrGgkxzJbnibsa3oUSMXezAJBgUrDgMCGgUAoIIBwzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzAzMDQxNTExNDRaMCMG
CSqGSIb3DQEJBDEWBBS77Ls60d2g7mAWatuzgErroDrssjBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6xoJMcyW54m7Gt6FEjF3swgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6x
oJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEBBQAEggEAfGpoHwE9lLv2Rsy84lBdeoBAWyDK
Qdfl2zuYilac1eMYGFJ6cROvJ/sl5tW9dImYzCcGBEkFXtfpA1hhh0v/ooz8RVmAQ47+hxoU
Y/h7mDXD9/5/pIQUJLsO/7l9Rqg3xsJ+fNZRCPcgT6gwItEM6uLq8mv73dK1/yuwWsdeMf64
QHBVU/YwUK8KSWg2Ecn3CJV/T/SE8jsFM+LrKoTVfav0Jm0bqFCa0Cj28njq9pFQaVKXRAir
BpQeGF+uoKmPkFg5arjkF9c6wHYwzeXGnYoVWH1e1i3keMPq6gvqP/PoXESz4BiVupGFzetY
N8fPwx34ZHhed6M7t05iL9mKNAAAAAAAAA==
--------------ms080206090207010600000807--
