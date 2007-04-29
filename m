Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbXD2Kmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbXD2Kmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXD2Kmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:42:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:14650 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXD2Kms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=C/e87mKdLytUy3OfIEHTXO7BA6r66d6KZEhOleoy6wOdWDMSc3w/juQd1J3MZvMslhRYzMXnKqJnVw/EOyLPjOOQ/fMUxFUGCiKBwPOoz2YWry2QdnLP4dJ3JcV9pudN4keb2pMiaJvOOQpBQsl+pDnju7j2AkdFobcu0yVNJlM=
Message-ID: <463476A3.9050305@gmail.com>
Date: Sun, 29 Apr 2007 12:42:43 +0200
From: Maciej Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [2.6.21-rc7-mm2] BUG while suspend to ram
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms040002050109070601040409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040002050109070601040409
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

BUG: at kernel/kthread.c:166 kthread_bind()
 [<c01465ac>] _cpu_down+0x16c/0x250
 [<c0146890>] disable_nonboot_cpus+0x60/0xf0
 [<c014cd67>] pm_suspend_disk+0x177/0x2c0
 [<c014b645>] enter_state+0xb5/0x200
 [<c014b84d>] state_store+0xbd/0xd0
 [<c014b790>] state_store+0x0/0xd0
 [<c01be189>] subsys_attr_store+0x29/0x40
 [<c01be3a4>] sysfs_write_file+0xd4/0x160
 [<c017b701>] vfs_write+0xc1/0x160
 [<c01be2d0>] sysfs_write_file+0x0/0x160
 [<c017be11>] sys_write+0x41/0x70
 [<c0187355>] sys_dup2+0xd5/0x100
 [<c01040f6>] sysenter_past_esp+0x5f/0x85
 [<c0330000>] xfrm_policy_insert+0x210/0x400
 =======================

dmesg:
http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/dmesg.txt.gz
lsmod:
http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/lsmod.txt.gz
ver_linux:
http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/ver_linux.txt.gz
lspci:
http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/lspci.txt.gz
config:
http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/config-2.6.21-rc7-mm2.gz

-- 
Maciej Rutecki <maciej.rutecki@gmail.com>
www.unixy.pl
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)


--------------ms040002050109070601040409
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
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzA0MjkxMDQyNDNaMCMG
CSqGSIb3DQEJBDEWBBR1drpDLMeGNv3M2lSX1PW8SubqgTBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6xoJMcyW54m7Gt6FEjF3swgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6x
oJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEBBQAEggEAvYhigsM5mP7ooe3g9sTjeP6OpSfd
MHionrkG0kVoYnzRz9aARNoJt52t5Iy0sSPVombgBF7+MAxddQPe1xCGFrI6I9Q7/uTvmJ6H
1YksBMsuDe4jX+tFksedL5gtXOGMzcqfwgG8qdv5rWbGP4I/tCmoemSey/4aAEwMl6BrU3th
lsAuarfuxI74CJhmVYeKfLkCT/lVxGWqmArgxoo5VKuMtcgPByyzE+OqfPDcB0OeR4WpM+/h
SIDVkewg4CX4dO1D7qN42cxFnfbiN4XBLrPmYp2NS735ppAQBJl1mdjJbTMI0Jdo+hKXGDwP
ylhkX1tFw9Jq4oywbqD81pjnpAAAAAAAAA==
--------------ms040002050109070601040409--
