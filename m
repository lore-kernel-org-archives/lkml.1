Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXDNItM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXDNItM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXDNItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:49:12 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:34932 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbXDNItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:49:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: multipart/signed;
	micalg=sha1;
	protocol="application/x-pkcs7-signature";
	boundary="=-CdQy1jlXriZBYoKBbxs4"
Content-class: urn:content-classes:message
Subject: [TEST RESULT]massive_intr.c -- cfs/vanilla/sd-0.40
Date: Sat, 14 Apr 2007 14:19:06 +0530
Message-ID: <1176540546.2702.15.camel@bluegenie>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [TEST RESULT]massive_intr.c -- cfs/vanilla/sd-0.40
Thread-Index: Acd+ccJVNZosEk8ySlyuQnpRyaTX0g==
From: <surya.prabhakar@wipro.com>
To: <mingo@elte.hu>, <kernel@kolivas.org>
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <npiggin@suse.de>, <efault@gmx.de>,
       <arjan@infradead.org>, <tglx@linutronix.de>, <wli@holomorphy.com>
X-OriginalArrivalTime: 14 Apr 2007 08:49:06.0908 (UTC) FILETIME=[C2DDF9C0:01C77E71]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CdQy1jlXriZBYoKBbxs4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ingo,
  Did a test with massive_intr.c on a standard linux desktop.
for vanilla, con's Sd-0.40 and cfs.

Test bed is a p4 2.26GHz, 512mb ram
No load on the machine expect for the X server.

Results are stated below

Vanilla Kernel=20
--------------------
2.6.21-rc6-vanilla #8 SMP Sat Apr 14=20

[surya@bluegenie tests]$ ./massive_intr 10 10
002469  00000548
002463  00000499
002464  00000026
002465  00000028
002472  00000021
002467  00000018
002470  00000015
002466  00000017
002468  00000024
002471  00000013

top output
top - 13:49:53 up 4 min,  3 users,  load average: 1.24, 0.71, 0.30
Tasks:  80 total,  10 running,  70 sleeping,   0 stopped,   0 zombie
Cpu(s): 13.3%us,  1.8%sy,  0.0%ni, 72.1%id, 12.7%wa,  0.1%hi,  0.0%si,
0.0%st
Mem:    506112k total,   440980k used,    65132k free,    31444k buffers
Swap:   522104k total,        0k used,   522104k free,   309560k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND           =20
 2469 surya     16   0  1624  204  132 S 33.8  0.0   0:00.30
massive_intr      =20
 2467 surya     22   0  1624  204  132 R 19.9  0.0   0:00.20
massive_intr      =20
 2466 surya     23   0  1624  204  132 R 15.9  0.0   0:00.20
massive_intr      =20
 2470 surya     24   0  1624  204  132 R 13.9  0.0   0:00.18
massive_intr      =20
 2468 surya     19   0  1624  204  132 R  8.0  0.0   0:00.19
massive_intr      =20
 2463 surya     19   0  1624  204  132 R  6.0  0.0   0:00.26
massive_intr      =20
    1 root      15   0  2032  640  548 S  0.0  0.1   0:00.72=20
 bash              =20
<snip>
 2462 surya     25   0  1624  428  356 S  0.0  0.1   0:01.63
massive_intr      =20
 2464 surya     20   0  1624  204  132 R  0.0  0.0   0:00.21
massive_intr      =20
 2465 surya     21   0  1624  204  132 R  0.0  0.0   0:00.20
massive_intr      =20
 2471 surya     20   0  1624  204  132 R  0.0  0.0   0:00.10
massive_intr      =20
 2472 surya     21   0  1624  204  132 R  0.0  0.0   0:00.20
massive_intr      =20
 2473 surya     15   0  2160  900  724 R  0.0  0.2   0:00.00 top    =20


SD-0.40
---------------

2.6.21-rc6-rsdl0.40 #6 SMP Sat Apr 14 13:08:31 IST 2007 i686 i686 i386
GNU/Linux
[root@bluegenie tests]# ./massive_intr 10 10
002504  00000125
002502  00000124
002500  00000123
002499  00000127
002501  00000125
002505  00000127
002506  00000127
002503  00000128
002498  00000124
002507  00000127

top - 13:42:50 up 5 min,  3 users,  load average: 2.03, 1.31, 0.61
Tasks:  80 total,  12 running,  68 sleeping,   0 stopped,   0 zombie
Cpu(s): 17.8%us,  1.4%sy,  0.0%ni, 69.8%id, 11.0%wa,  0.1%hi,  0.0%si,
0.0%st
Mem:    506112k total,   441664k used,    64448k free,    31592k buffers
Swap:   522104k total,        0k used,   522104k free,   310152k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND           =20
 2500 root      29   0  1620  204  132 R 11.2  0.0   0:00.28
massive_intr      =20
 2501 root      29   0  1620  204  132 R 11.2  0.0   0:00.30
massive_intr      =20
 2502 root      29   0  1620  204  132 R 11.2  0.0   0:00.30
massive_intr      =20
 2504 root      29   0  1620  204  132 R 11.2  0.0   0:00.30
massive_intr      =20
 2498 root      29   0  1620  204  132 R  9.3  0.0   0:00.29
massive_intr      =20
 2499 root      29   0  1620  204  132 R  9.3  0.0   0:00.28
massive_intr      =20
 2503 root      27   0  1620  204  132 R  9.3  0.0   0:00.27
massive_intr      =20
 2505 root      27   0  1620  204  132 R  9.3  0.0   0:00.29
massive_intr      =20
 2506 root      27   0  1620  204  132 R  9.3  0.0   0:00.28
massive_intr      =20
 2507 root      27   0  1620  204  132 R  9.3  0.0   0:00.28
massive_intr      =20
    1 root       5   0  2036  640  548 S  0.0  0.1   0:00.72
init              =20
<snip>
 2497 root       1   0  1620  428  356 S  0.0  0.1   0:01.69
massive_intr      =20
 2508 surya     27   0  2164  904  724 R  0.0  0.2   0:00.00 top    =20


CFS-kernel
----------------

2.6.21-rc6-cfs #7 SMP Sat Apr 14=20

pass1
-----
[surya@bluegenie tests]$ ./massive_intr 10 10
002435  00000120
002439  00000120
002441  00000120
002434  00000120
002436  00000120
002440  00000120
002432  00000120
002437  00000120
002433  00000120
002438  00000120

Felt it is too much fair, will try another pass ;)

[surya@bluegenie tests]$ ./massive_intr 10 10
002961  00000121
002965  00000120
002964  00000121
002959  00000120
002956  00000121
002963  00000121
002960  00000121
002962  00000121
002958  00000122
002957  00000122

top_output
---
top - 13:55:39 up 3 min,  3 users,  load average: 0.24, 0.46, 0.22
Tasks:  80 total,  11 running,  69 sleeping,   0 stopped,   0 zombie
Cpu(s):  6.7%us,  2.2%sy,  0.0%ni, 75.3%id, 15.7%wa,  0.1%hi,  0.0%si,
0.0%st
Mem:    506108k total,   438100k used,    68008k free,    31144k buffers
Swap:   522104k total,        0k used,   522104k free,   306932k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND           =20
 2439 surya     20   0  1620  204  132 R 12.7  0.0   0:00.24
massive_intr      =20
 2432 surya     20   0  1620  204  132 R 10.9  0.0   0:00.24
massive_intr      =20
 2441 surya     20   0  1620  204  132 R 10.9  0.0   0:00.25
massive_intr      =20
 2433 surya     20   0  1620  204  132 R  9.1  0.0   0:00.20
massive_intr      =20
 2435 surya     20   0  1620  204  132 R  9.1  0.0   0:00.23
massive_intr      =20
 2434 surya     20   0  1620  204  132 R  7.2  0.0   0:00.23
massive_intr      =20
 2436 surya     20   0  1620  204  132 R  7.2  0.0   0:00.20
massive_intr      =20
 2437 surya     20   0  1620  204  132 R  7.2  0.0   0:00.20
massive_intr      =20
 2438 surya     20   0  1620  204  132 R  7.2  0.0   0:00.22
massive_intr      =20
 2440 surya     20   0  1620  204  132 R  7.2  0.0   0:00.21
massive_intr      =20
    1 root      20   0  2036  640  548 S  0.0  0.1   0:00.72
init              =20
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00=20
<snip>           =20
 2431 surya     20   0  1620  428  356 S  0.0  0.1   0:01.65
massive_intr      =20
 2442 surya     20   0  2160  900  724 R  0.0  0.2   0:00.00
top               =20



  =20
Noticed considerable amount of load while running con's kernel.
cpu time is very very close to being fair in cfs. Will be trying out=20
ringtest in the next round.

thanks..       =20

--=20
surya.
14/04/2007

--=-CdQy1jlXriZBYoKBbxs4
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJIzCCAuww
ggJVoAMCAQICEG8zftGmvYfSeKA1FishBukwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDMyMjExNTExNloXDTA4MDMyMTExNTEx
NlowSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc3Vy
eWEucHJhYmhha2FyQHdpcHJvLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN/+
l9Kx40VowHNy1cV5enxc1UE6Dw52tCjR1fyyTrYXdb8Xir04OhwY+++irn6eIMFclcTVAHfTXgWR
rXgBmi1AcFPy2zhDwHOc9f4Kj+KMddJYKe5zSdh8KqRXgAr8MoZ1fBiq/KrKZq9vUzwCW3Q0nJDC
S8c3zG1GPQMmQZCYdoXiuFEmPOYqiNmu3gCJicTs9lgxB6j+5XiGcHrn8KHlHe3kqODpMHfVnxmk
Y/Z1A0NkDfFwbqNj/85zTAusk3ZLqvSRScR0F3AA132aZ1LA0tVG6a1u8Ki5cpQrgFvkF1eFqUiu
DMht+EUkzaW25I8Lbon1YCEko5DARpRhc9ECAwEAAaM2MDQwJAYDVR0RBB0wG4EZc3VyeWEucHJh
Ymhha2FyQHdpcHJvLmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAAMG17rbLz6X
A1n8zcIjX8+oGrJIaOo2metS9rZ/muMfvz5tqhrrWGaFxbwjy6czu13wkryXnEHuzQ+P1RYi4MLe
ai6xAXzfjDIbJvUfbhp4gUxtDgJQa+QjS3BDwh55iG2KuBLa3yM6Z1ot4i6J4+rUcMSrlAaDx+e2
yEPbqp8gMIIC7DCCAlWgAwIBAgIQbzN+0aa9h9J4oDUWKyEG6TANBgkqhkiG9w0BAQUFADBiMQsw
CQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UE
AxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDcwMzIyMTE1MTE2WhcN
MDgwMzIxMTE1MTE2WjBLMR8wHQYDVQQDExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMSgwJgYJKoZI
hvcNAQkBFhlzdXJ5YS5wcmFiaGFrYXJAd2lwcm8uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEA3/6X0rHjRWjAc3LVxXl6fFzVQToPDna0KNHV/LJOthd1vxeKvTg6HBj776Kufp4g
wVyVxNUAd9NeBZGteAGaLUBwU/LbOEPAc5z1/gqP4ox10lgp7nNJ2HwqpFeACvwyhnV8GKr8qspm
r29TPAJbdDSckMJLxzfMbUY9AyZBkJh2heK4USY85iqI2a7eAImJxOz2WDEHqP7leIZweufwoeUd
7eSo4Okwd9WfGaRj9nUDQ2QN8XBuo2P/znNMC6yTdkuq9JFJxHQXcADXfZpnUsDS1UbprW7wqLly
lCuAW+QXV4WpSK4MyG34RSTNpbbkjwtuifVgISSjkMBGlGFz0QIDAQABozYwNDAkBgNVHREEHTAb
gRlzdXJ5YS5wcmFiaGFrYXJAd2lwcm8uY29tMAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQAD
gYEAAwbXutsvPpcDWfzNwiNfz6gaskho6jaZ61L2tn+a4x+/Pm2qGutYZoXFvCPLpzO7XfCSvJec
Qe7ND4/VFiLgwt5qLrEBfN+MMhsm9R9uGniBTG0OAlBr5CNLcEPCHnmIbYq4EtrfIzpnWi3iLonj
6tRwxKuUBoPH57bIQ9uqnyAwggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYD
VQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNV
BAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERp
dmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0B
CQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2
MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8M
OmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsY
Pge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/
BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3Rl
UGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNV
BAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+v
rL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sn
cVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYID
EDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0
eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEG8z
ftGmvYfSeKA1FishBukwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDcwNDE0MDg0OTAyWjAjBgkqhkiG9w0BCQQxFgQUeK/3p198yGbNy8b4
Gd3+I5bV9EwwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0
ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhBvM37Rpr2H0nigNRYrIQbpMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhBvM37Rpr2H0nigNRYrIQbpMA0G
CSqGSIb3DQEBAQUABIIBACmOtXf4Ezs2Td/SUx7SV4BD1MT5tM6BGvNuYf3CkaKgFt2aPoNt5gOL
LJ8n7rp1z+Yp2yPPlufLWWpsVKtMVKjeh3H0HZtpuHuL3xGRz7TaAdd+F/SacDQq5Z8osx6q1Jb0
8CL2mjhyWhdlt2k16fO+bZyHUakpsqeHWj8oPukkbHBQu9aOxQa9miwspFAxrKrgeOnNDPrkX6sG
H14we86xrE52Zd1QpHvNpLEF+NdhZswMCU/9hvORwbK58RQNPfdphlQGuT2yvk01gxE13h3ToerO
DzG9QKzZuLgyK4nbPTeUb18LCfSi5Yx6C5aeRxSeg4ZC/OpXhO0r2h0CyggAAAAAAAA=


--=-CdQy1jlXriZBYoKBbxs4--
