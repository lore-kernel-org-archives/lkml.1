Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYE3Nvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYE3Nvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYE3Nvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:51:42 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:43005
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbYE3Nvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:51:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 09:51:40 EDT
Message-Id: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com>
From: Guntsche Michael <mike@it-loops.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; boundary=Apple-Mail-1--227822319; micalg=sha1; protocol="application/pkcs7-signature"
Mime-Version: 1.0 (Apple Message framework v924)
Subject: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Date: Fri, 30 May 2008 15:44:55 +0200
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-1--227822319
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi list,

I recently upgraded one of my servers from 2.6.24.2 to 2.6.25. This is  
more or less a basic fileserver that also does some compilations from  
time to time.

cat /proc/cpuinfo from 2.6.24.2:

processor : 0
vendor_id : GenuineIntel
cpu family  : 15
model   : 1
model name  : Intel(R) Pentium(R) 4 CPU 1.70GHz
stepping  : 2
cpu MHz   : 425.000
cache size  : 256 KB
fdiv_bug  : no
hlt_bug   : no
f00f_bug  : no
coma_bug  : no
fpu   : yes
fpu_exception : yes
cpuid level : 2
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca  
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts  
sync_rdtsc
bogomips  : 3401.38
clflush size  : 64

scaling_available_frequencies (p4-clockmod): 425000 637500 850000  
1062500 1275000 1487500 1700000

Since the server is idling most of the time I enabled the ondemand  
governor and installed p4-clockmod. I read that this is not the best  
solution but acpi-cpufreq is not working for me.

Everything was good with 2.6.24. After switching to to 2.6.25 I have  
the following output.

cat /proc/cpuinfo from 2.6.25.4:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 1
model name	: Intel(R) Pentium(R) 4 CPU 1.70GHz
stepping	: 2
cpu MHz		: 3450.000
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov  
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts
bogomips	: 3402.06
clflush size	: 64

scaling_available_frequencies (p4-clockmod): 3450000 5175000 6900000  
8625000 10350000 12075000 13800000

The scaling is working but the frequencies are way of. Every value is  
multiplied by ~8.12.
I get the same result with 2.6.25 and 2.6.25.4.
I am not sure if this is only a display related problem, or if  
something more serious is causing this.

Please CC me on any replies since I am not subscribed to the list.

Kind regards,
Michael








--Apple-Mail-1--227822319
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGIzCCAtww
ggJFoAMCAQICEBd4Zp9b22liUjK/V/e8ZTUwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MTAzMTE2MDMwMVoXDTA4MTAzMDE2MDMw
MVowQzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEgMB4GCSqGSIb3DQEJARYRbWlr
ZUBpdC1sb29wcy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/D9ePLG2ZNk/Z
NXTRfUq7Rs+3k5M/nqmZ8riQYRnt8sCTj6o/fPS4qjaDf9jRfgbxViROiShFWMoBNJkKg91doJFk
FYdive8ujFfKpPR6FVGu8rN/sHUZM/gowZUcqDyIMAJVr7iiWhQYxP3U4hmprJsmUaGkjBU37Bcw
vJnEZ4gDCgYiZLiHUACDDfsl2xl5r6XvtXV9TsjWA3eQSeju68nQFP0PjFU+UtYfr3z1nFMJpuzE
xStjCEZ+EkYBOHK+RmBaOLEfF2Rq8175oaX5ScotY61s7wjADYesS//bvdcZ11jf/R+UCE90p8iC
Y1TjqqRv+zMc+VpyfG1dt9ELAgMBAAGjLjAsMBwGA1UdEQQVMBOBEW1pa2VAaXQtbG9vcHMuY29t
MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAgVh3S3v4j1ydxqgc/DWXcO5RRnyfLTjU
bJwYwTdaQVuykeXrT+2ITDIpOpVEqZ7xV/N9aKMM/izyQ8oMvw/J13TUm1N77kNCp5jYy1S+Ntuz
bCdOdFVA5tFVn/nMfmK1Is6NjK+0GmryYPEpn8vaP9ZGy57wCpKZrwmytgm3oPQwggM/MIICqKAD
AgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBD
YXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYD
VQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVy
c29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0
ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVz
VftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Va
qj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20Txh
BEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0
hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNV
HQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqG
SIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCT
cDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo0
5RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTEl
MCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBd4Zp9b22liUjK/V/e8ZTUwCQYFKw4DAhoFAKCC
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwNTMwMTM0NDU1
WjAjBgkqhkiG9w0BCQQxFgQUewsPbA4d4LkQyKVaxxvo5vZs2zswgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBAINL2GkhlPdWYu6b
rFtxMbW+UCUEkz4tn7lYyRJuZs8+wBgeX5S7IKVED65M9PSMVLPeq+907Ax+T5r2reMVHLWkq9lU
UsHUYaD8LfJQtD77owTxIf94wLSlhs9juhJZRXNbvz6qBSijWLuv6WZ60JG/P5EIkVwzt3JDn6pJ
J3SCpn8VzksiSodxl/kJMQ3TagHYSaTvAYtblsApE9+P3MsE06A6HPUBuwmYuj+7sk/7BOZyDJmi
CPLa0ekyWHQ/RvoopY8pki4M/SwU+a9pzUPDJ35LGaeph0N9scuELjXwBFkLNbS0Ox9Sa1fC8WwX
X0gWUkDvMJAQbk/ARdWeTp4AAAAAAAA=

--Apple-Mail-1--227822319--
