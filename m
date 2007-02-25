Return-Path: <linux-kernel-owner+w=401wt.eu-S965061AbXBYSfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061AbXBYSfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965075AbXBYSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:35:17 -0500
Received: from s0001.shadowconnect.net ([88.198.24.147]:46680 "EHLO
	mail.shadowconnect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061AbXBYSfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:35:15 -0500
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 13:35:15 EST
Message-ID: <45E1D1A8.7050901@shadowconnect.com>
Date: Sun, 25 Feb 2007 19:12:56 +0100
From: Markus Lidel <Markus.Lidel@shadowconnect.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Gray <mvg001@markvgray.com>, linux-kernel@vger.kernel.org,
       Sam Hokin <sam@ims.net>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: I2O block driver broken in kernel 2.6.19?
References: <45D8E102.6090004@redhat.com>	<loom.20070223T235432-923@post.gmane.org> <20070224030924.e2b0fcce.akpm@linux-foundation.org>
In-Reply-To: <20070224030924.e2b0fcce.akpm@linux-foundation.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms030307030401080407060304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030307030401080407060304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

Andrew Morton wrote:
> (cc's restored.  Please, always do reply-to-all)
>> On Fri, 23 Feb 2007 22:57:27 +0000 (UTC) Mark Gray <mvg001@markvgray.com> wrote:
>>>  i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
>>> Buffer I/O error on device i2o/hda, logical block 0
>> Same error here. Both 2.6.19 and 2.6.20 kernels, using Adaptec 2400A RAID.
> Is Adaptec 2400 controlled by drivers/message/i2o? I assume so...
> If so, thats's at least three people reporting breakage in 2.6.19 and later.
> Is anyone able perform a git-bisect to identify the offending commit?  It
> would really help.
> Thanks.

I've already reversed the changes from 2.6.19 for the I2O subsystem, but 
it wasn't the solution. Probably it has something to do with the DMA 
handling, because some commands go through very well, while others 
don't. I'm working on the issue and report back as soon as i find a 
solution.


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com

Geschäftsführer/CEO: Markus Lidel
HRB 10357, Amtsgericht Memmingen

--------------ms030307030401080407060304
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJUTCC
AwMwggJsoAMCAQICEAhPjzaw/32e9mQOW/Zli3owDQYJKoZIhvcNAQEEBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDQxMDE2NDg0MloX
DTA3MDQxMDE2NDg0MlowgeAxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xETAPBgNV
BAcTCEtydW1iYWNoMScwJQYDVQQKEx5TaGFkb3cgQ29ubmVjdCBHbWJIIChJbnRlcm5ldCkx
HTAbBgNVBAwTFFNlbmlvciBJVCBDb25zdWx0YW50MQ4wDAYDVQQEEwVMaWRlbDEPMA0GA1UE
KhMGTWFya3VzMRUwEwYDVQQDEwxNYXJrdXMgTGlkZWwxLTArBgkqhkiG9w0BCQEWHk1hcmt1
cy5MaWRlbEBzaGFkb3djb25uZWN0LmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA
yknWBzALDg1PobgTc7XwpX/KkmBfZqIKUDQzifj379tzvaaGFkdySSYhHTWK3EjNneuKCkx0
B0FILFLyL59I6PJLh1xvl34JiqzHt1B8VgR05/r0tx3aHn6SyT2Wx8KethLZloqb27W2/Hfb
fteXGcZzhepOHvKkDiEkwMnuIi0CAwEAAaM7MDkwKQYDVR0RBCIwIIEeTWFya3VzLkxpZGVs
QHNoYWRvd2Nvbm5lY3QuY29tMAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEEBQADgYEAAxUl
pLJ0d8C3+FREKRKeU/B4n9kefOkBWr0GeYCmw92Umkryr5Radlr1CU1S+L81KerOR2vAhskV
610BbaF1Ibd1DoZ6jzR076RLcD7FFT4NjS8wY5zXiGmcb7y3YpkNuCdkfWSWNP34+LOKW1ev
d4QZLtCVFxpl5ava/8slz2wwggMDMIICbKADAgECAhAIT482sP99nvZkDlv2ZYt6MA0GCSqG
SIb3DQEBBAUAMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAo
UHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBD
QTAeFw0wNjA0MTAxNjQ4NDJaFw0wNzA0MTAxNjQ4NDJaMIHgMQswCQYDVQQGEwJERTEPMA0G
A1UECBMGQmF5ZXJuMREwDwYDVQQHEwhLcnVtYmFjaDEnMCUGA1UEChMeU2hhZG93IENvbm5l
Y3QgR21iSCAoSW50ZXJuZXQpMR0wGwYDVQQMExRTZW5pb3IgSVQgQ29uc3VsdGFudDEOMAwG
A1UEBBMFTGlkZWwxDzANBgNVBCoTBk1hcmt1czEVMBMGA1UEAxMMTWFya3VzIExpZGVsMS0w
KwYJKoZIhvcNAQkBFh5NYXJrdXMuTGlkZWxAc2hhZG93Y29ubmVjdC5jb20wgZ8wDQYJKoZI
hvcNAQEBBQADgY0AMIGJAoGBAMpJ1gcwCw4NT6G4E3O18KV/ypJgX2aiClA0M4n49+/bc72m
hhZHckkmIR01itxIzZ3rigpMdAdBSCxS8i+fSOjyS4dcb5d+CYqsx7dQfFYEdOf69Lcd2h5+
ksk9lsfCnrYS2ZaKm9u1tvx3237XlxnGc4XqTh7ypA4hJMDJ7iItAgMBAAGjOzA5MCkGA1Ud
EQQiMCCBHk1hcmt1cy5MaWRlbEBzaGFkb3djb25uZWN0LmNvbTAMBgNVHRMBAf8EAjAAMA0G
CSqGSIb3DQEBBAUAA4GBAAMVJaSydHfAt/hURCkSnlPweJ/ZHnzpAVq9BnmApsPdlJpK8q+U
WnZa9QlNUvi/NSnqzkdrwIbJFetdAW2hdSG3dQ6Geo80dO+kS3A+xRU+DY0vMGOc14hpnG+8
t2KZDbgnZH1kljT9+PiziltXr3eEGS7QlRcaZeWr2v/LJc9sMIIDPzCCAqigAwIBAgIBDTAN
BgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTES
MBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3dGUgQ29uc3VsdGluZzEoMCYGA1UE
CxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0
aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAwMFoXDTEzMDcxNjIzNTk1OVowYjELMAkGA1UEBhMC
WkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1Ro
YXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUAA4GN
ADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAK
MNcCY1osiRVwjt3J8CuFWqo/cVbLrzwLB+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTX
p6a7n2XRxSpUhQ9IBH+nttE8YQRAHmQZcmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYB
Af8CAQAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBl
cnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0PBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYD
VQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG9w0BAQUFAAOBgQBIjNFQg+oLLswNo2as
Zw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAgk3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSe
JVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghOrvbqNOUQGls1TXfjViF4gtwhGTXeJLHT
HUb/XV9lTzGCAuMwggLfAgEBMHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhAIT482sP99nvZkDlv2ZYt6MAkGBSsOAwIaBQCgggHDMBgGCSqGSIb3
DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDIyNTE4MTI1NlowIwYJKoZI
hvcNAQkEMRYEFH2vmUKcz6ATPn3kK+1Rynnq30lrMFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZI
hvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3
DQMCAgEoMIGFBgkrBgEEAYI3EAQxeDB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQQIQCE+PNrD/fZ72ZA5b9mWLejCBhwYLKoZIhvcNAQkQAgsxeKB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQCE+PNrD/
fZ72ZA5b9mWLejANBgkqhkiG9w0BAQEFAASBgBvo/8ubMxX0giEUyNygr/mi7bPZFDqUphBX
83lzX0JLtmNTAhdtAMHDIgD8deyqbpo+vhH79WIuTjs9ij2TeIZ+8ploNJ5Q4aeukQRthhnd
IpsRxJTZabf1decsXKaTyDyVxzHkw3nRTG4/JeTB8Y0/7dCTeZnlu3r++SwumlALAAAAAAAA

--------------ms030307030401080407060304--
