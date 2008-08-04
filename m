Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbYHDX2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbYHDX2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbYHDX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:27:56 -0400
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80]:47195 "HELO
	smtp102.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757034AbYHDX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:27:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=D8SX0jdHIaF7Q+KU5Y0ckDwLtQPpTE7AoJmAl0ZVStSILK5V9P+g30hBludMp2PrhMb+n1DhxoOs4rxP06MXq0aKfwSI07mnsE4+LtbPI1Gg1gQCd18F9oJ33INpNg+XSCo9gnArkxONZXmKSXBQkCkYi914fNbPXEklE7kS16Q=  ;
X-YMail-OSG: hViQspIVM1ldRdBUTn09IvWznw.q2HY3VXmrEjzhDhcJss8rLD83ozMAkoHWWwWITA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48979079.9030409@rogers.com>
Date: Mon, 04 Aug 2008 19:27:53 -0400
From: David Stuart <dstuart@rogers.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with disk + network on 2.6.25.11-60.fc8
References: <48973EB9.90408@rogers.com>	<20080804184232.601881a8@lxorguk.ukuu.org.uk>	<4897671F.1050003@rogers.com> <20080804214441.0811138e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804214441.0811138e@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms040705080200050909010402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040705080200050909010402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> Ok so the pdc202xx_old hardware flakes out when you have very high
> network load (I'd guess in fact very high bus traffic).
>
> The actual log is the disk I/O timing out, then the drive being busy
> (probably due to the timeout and a DMA transfer getting stuck). We reset
> it and carry on.
>
> Libata happens to log this a lot more visibly than old kernels which is
> useful but does mean people sometimes don't notice.
>
> The rest then fits - the freeze I'd expect as we block I/O while trying
> to get the drive back.
>
> Doubt the Nvidia module is involved as I'd then expect problems under
> high graphical load but you can certainly test that. I don't suppose
> you've got a spare PCI network card you could try instead to see if it is
> the network card bits ?
>
> Alan
>   

Hi Alan,

Actually I do not really have another PCI network card, but I could 
switch the computer back to the other interface which is on the 
motherboard (does that one function as a PCI device?). As I mentioned in 
my first post, the current card I am using is an attempt to try to work 
around the problem (originally I thought it was the on-board 
controller), so I have my doubts as to whether switching back would help.

Nonetheless, I will give it a try again and let you know the result.

Thanks,
David

-- 
The only way to keep your health is to eat what you don't want, drink
what you don't like, and do what you'd rather not.
                -- Mark Twain


--------------ms040705080200050909010402
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJBzCC
At4wggJHoAMCAQICEHcAGlDwU0NqjFetNQ2D/hEwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDcxMjE2MDQ0NFoX
DTA5MDcxMjE2MDQ0NFowRDEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEhMB8G
CSqGSIb3DQEJARYSZHN0dWFydEByb2dlcnMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAqUMveSpJ7k7kMyf5zbslvkiz9VGDfcnCQNOFLaw9y6j0jPvvkgIXtslpofj0
3/eARmjszsn/24Zn1/Iufz3xuc/XYYn7lQgf1PCTeV8bYTq81Kvh6srKbrYmPz06uXVhtGQC
vWuKL3SLtX3jI4ah5L/te5w+x/MDaflM8N0xb0UlRGeR80FwFSzk1qh+vyx+hWoUz0Gdmuc/
4AZUBvl3PzD0fNZP3FS8k7aBuAAQT1H5iUag8BFWmqAiR1QYWsjpcK4VwSfeSTDsEK7rcU4K
ukbhuxITTWrQHDqJJAIopvP8FocH/uAumuNFsZLp6jvJNOft02TiGuU2CWAL1ZCW9wIDAQAB
oy8wLTAdBgNVHREEFjAUgRJkc3R1YXJ0QHJvZ2Vycy5jb20wDAYDVR0TAQH/BAIwADANBgkq
hkiG9w0BAQUFAAOBgQBHbO5t4ZukqhZfwdR6RqNujNssesMxKwU2w/lXNxoPH5RssWsN3xi4
1AAJ8wAnEeuHqJi4TMVF6lMWAOSuJO/OQR2gDBysHT29jrJn0bUqgOeT7KC6A7wtjabbLK0n
/DK2cZovx/xBgVjWl7hpvk5qw6Clr4R21DbrA/GOMGcE8TCCAt4wggJHoAMCAQICEHcAGlDw
U0NqjFetNQ2D/hEwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRo
YXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBG
cmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDcxMjE2MDQ0NFoXDTA5MDcxMjE2MDQ0NFowRDEf
MB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEhMB8GCSqGSIb3DQEJARYSZHN0dWFy
dEByb2dlcnMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqUMveSpJ7k7k
Myf5zbslvkiz9VGDfcnCQNOFLaw9y6j0jPvvkgIXtslpofj03/eARmjszsn/24Zn1/Iufz3x
uc/XYYn7lQgf1PCTeV8bYTq81Kvh6srKbrYmPz06uXVhtGQCvWuKL3SLtX3jI4ah5L/te5w+
x/MDaflM8N0xb0UlRGeR80FwFSzk1qh+vyx+hWoUz0Gdmuc/4AZUBvl3PzD0fNZP3FS8k7aB
uAAQT1H5iUag8BFWmqAiR1QYWsjpcK4VwSfeSTDsEK7rcU4KukbhuxITTWrQHDqJJAIopvP8
FocH/uAumuNFsZLp6jvJNOft02TiGuU2CWAL1ZCW9wIDAQABoy8wLTAdBgNVHREEFjAUgRJk
c3R1YXJ0QHJvZ2Vycy5jb20wDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBHbO5t
4ZukqhZfwdR6RqNujNssesMxKwU2w/lXNxoPH5RssWsN3xi41AAJ8wAnEeuHqJi4TMVF6lMW
AOSuJO/OQR2gDBysHT29jrJn0bUqgOeT7KC6A7wtjabbLK0n/DK2cZovx/xBgVjWl7hpvk5q
w6Clr4R21DbrA/GOMGcE8TCCAz8wggKooAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJ
BgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEa
MBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2Vy
dmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTEr
MCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcw
MDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUg
Q29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1h
aWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065ypla
HmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FW
y688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEE
QB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2
oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3Js
MAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0x
MzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYf
qi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9l
X5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk13iSx0x1G/11fZU8xggNxMIIDbQIBATB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQdwAaUPBT
Q2qMV601DYP+ETAJBgUrDgMCGgUAoIIB0DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0wODA4MDQyMzI3NTNaMCMGCSqGSIb3DQEJBDEWBBQFBNU/ZkTSDla2
uuJUzn+1V4k1gDBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25z
dWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUNg/4RMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUN
g/4RMA0GCSqGSIb3DQEBAQUABIIBACm2EvWNPjWTTu5xvs4iA2yiXK1gh+LFM8rr5dqkjO0a
KHg2V/lJW1Rw8LZe9AIRbeu62ZPOkLH9EPHLWfKJ4/Xd8GMXDwiO9fNXFnPTk78oSmk3lN95
J7Lhe1QxvfAgmMJR5K+YKa5TYVDGXZFVX+WDELXugPTtwEgDf1k6OlelunHu3Wn+lszOAWSI
1nw5HKUWB55YQTwB0Tvcj215Sbg1OieH3snvWB2vsQWDrGYNd50G/wRNMoRwkCvepNRecGy0
r0+CyHHTGtB4fycv/aetv+2i6RTQscYHYS4qQfU/ZbvFlzJhuk+mDryW3RK2i+tDXBj9Sl5r
2eyqZBIF+iEAAAAAAAA=
--------------ms040705080200050909010402--
