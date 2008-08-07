Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYHGBn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYHGBn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 21:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYHGBnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 21:43:21 -0400
Received: from smtp118.rog.mail.re2.yahoo.com ([68.142.225.234]:25492 "HELO
	smtp118.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752317AbYHGBnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 21:43:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=JLZm0Z/3TzVUzedJpCGIwkVBw2qc+QamOHbbkDfiEH5/Ys+6m7WhsJ+mqxdohsU67/q3GzImkU4l/pn1X43+Qoa6lomId4crpjvtqEeJzPcbIELBr0Te4RsqfUnkmBhgB4bJ85Gs2Gq8EXNdzvesTVPdt5LsjrAxMwwFf2IC3kE=  ;
X-YMail-OSG: cEgSdkMVM1nwoozd48TYx_cq7Pp.vqGQ6om_XypwSsbOXBWvhKV997l8p67v1iDpaw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <489A5336.5080904@rogers.com>
Date: Wed, 06 Aug 2008 21:43:18 -0400
From: David Stuart <dstuart@rogers.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Stuart <dstuart@rogers.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Problems with disk + network on 2.6.25.11-60.fc8
References: <48973EB9.90408@rogers.com>	<20080804184232.601881a8@lxorguk.ukuu.org.uk>	<4897671F.1050003@rogers.com>	<20080804214441.0811138e@lxorguk.ukuu.org.uk>	<48979079.9030409@rogers.com> <20080805001330.6d43bcbb@lxorguk.ukuu.org.uk> <489797A8.408@rogers.com>
In-Reply-To: <489797A8.408@rogers.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050001040600020309010500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050001040600020309010500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Stuart wrote:
> Alan Cox wrote:
>> That would be great - if it makes no difference, yet high network 
>> traffic
>> is the key factor then it mostly eliminates bugs in the network drivers
>> from suspicion. At that point its time to dig deeper into the chip 
>> config.
>>   
>
> Hi Alan,
>
> So I switched back to my old on-board network card (removing the prior 
> card altogether from the case). I tried my test-case, which involves 
> downloading some big files while simultaneously running a find command.
>
> I *was* able to reproduce the issue fairly quickly.
>
> The key difference is that this time I was using the skge kernel 
> module for networking. So, I tend to agree that it is most likely not 
> a network driver problem.

Hello,

It occurs to me that you might be implying there is some "chip config" 
that I can retrieve and give to you. Is there anything I can/should do 
in order to give you more information, or is this pretty much out of my 
hands at this point?

Should I be filing a bug report for this?


-- 
The only way to keep your health is to eat what you don't want, drink
what you don't like, and do what you'd rather not.
                -- Mark Twain


--------------ms050001040600020309010500
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
CSqGSIb3DQEJBTEPFw0wODA4MDcwMTQzMThaMCMGCSqGSIb3DQEJBDEWBBRniHZDAuehx+Rk
xf7yPTRVY94oLDBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25z
dWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUNg/4RMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUN
g/4RMA0GCSqGSIb3DQEBAQUABIIBACWwv6HXJ+CoqfTKkwk1b9Sxhe30mG0Oz1azBlKUls2C
z11j25g8jKRkBJeP1ISYE7buCDkqWyefux7lp628NaUcGLCpn/3twzc7D9NyB36EzW1C5DyU
VMqv4JmdgAHxyqWS39Aa40d+6NDN4NQxKL1giMq/tBVN/KlSX7twJQ1JhxVgofPoxkCduA4m
zBVBuJOtj6F/7JehLk7PSvnOMLplb0kPlXj/L8F/Wu0QZ2Qx03USxFaoD8UvnKZWk2zvNKuQ
0/5OTFRILd3km7ZjhTGqObOoZ+EAf4zcCcwMxWpuy1+BDW+sF2ku5bsVylOJK5DXoBMzdlO4
GJ7FMR642XwAAAAAAAA=
--------------ms050001040600020309010500--
