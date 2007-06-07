Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbXFGKau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbXFGKau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXFGKaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:30:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:28002 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbXFGKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=SLPSEGjBfgVBGZl3GceDi7wYqucoI6P4ErwW3Ho4EJN99k5/l1AcH+RFKtI7PWTR+XkIBswP2IwiOk+M4lZNPdRWAQ8x6f7qtaA5Xm/Wa02rHSG5jBQ3MsuYhkOPmovaF8xI/r68tF4Nwi9UTecu5vJJUj64cR8ctL3pC0PLIuY=
Message-ID: <4667DE48.1030401@gmail.com>
Date: Thu, 07 Jun 2007 12:30:32 +0200
From: Maciej Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [2.6.22-rc4-mm1] ACPI Exception (processor_throttling)
References: <20070606020737.4663d686.akpm@linux-foundation.org>	 <4667B970.7000506@gmail.com> <3877989d0706070209y7fc4518ai785dae5da0c92558@mail.gmail.com>
In-Reply-To: <3877989d0706070209y7fc4518ai785dae5da0c92558@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080107010400000609070902"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080107010400000609070902
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Luming Yu pisze:
> Please test the attached patch.
> 

It works. I still have exceptions in dmesg (probably my dsdt doesn't
support _PTC and _TSS), but already I can read
/proc/acpi/processor/CPU0/throttling:

maciek@rutek:~$ cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  00%
    T1:                  12%
    T2:                  25%
    T3:                  37%
    T4:                  50%
    T5:                  62%
    T6:                  75%
    T7:                  87%

> Thanks,
> Luming
> 

Thanks for help.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl

--------------ms080107010400000609070902
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
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzA2MDcxMDMwMzJaMCMG
CSqGSIb3DQEJBDEWBBT3AHG+fAIUDnG+veaNdmFLgYmuzzBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6xoJMcyW54m7Gt6FEjF3swgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6x
oJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEBBQAEggEAWkiY9LkdZyfua9n3+x9kpWZasew6
KZc8kVGlWLa2F1hqP1WU4WN/zTjgtahW9E5IGXCDGzi8XbWiNz+V7/Joi7JLNoQ1uV111zBF
KdLscYhFx7W+MV5ytkn9M8xe029UQhZxBeqZVbBRq6aej5fsWWGAZ02NaF7sc2p7aSil31lZ
KkYvK2aVTcXWH756qt/Mup1yRKUmzbC3mAlSQobCKcnzY8m+pnJyUhNt6eRQAkbSYyZEN+mT
zN1LT2ND/XxgluOQHvmlEYW1hebKgNt62u9sA8pQUN2Zn/8BZPnJydYXfDCPnQ7Ut6DKQLo/
ocpDPsEz+D4hJl3I7URa3p+OeQAAAAAAAA==
--------------ms080107010400000609070902--
