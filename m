Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYHMSJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYHMSJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYHMSI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:08:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:51009 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYHMSI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=yAAmfkw7dduvbm7+07KW1CG+5TXzHKXHd8oi3lQqwhH2gM+76NDdN9QCwpKN/ZVDGl
         WM45HWK8ikUXp80gs4Hd7DIfD53oZPBiB0GtWwhHYsABY50imsNI/eaDkGVHrxtqNrmA
         bK+rf2bE2BCaQ6xBZThjk21IJE38uwWsvQLuY=
From: Bruce Duncan <bwduncan@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Subject: Re: [git pull] ftrace for v2.6.27
Date: Wed, 13 Aug 2008 19:08:42 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
References: <20080714142226.GA11412@elte.hu> <200808130248.58216.bwduncan@gmail.com> <48A316A2.9080907@redhat.com>
In-Reply-To: <48A316A2.9080907@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart34821353.4hYG5gOAhL";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808131908.48721.bwduncan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart34821353.4hYG5gOAhL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 13 August 2008 18:15:14 Steven Rostedt wrote:
> Seems that the issue is with the "ftraced" daemon. The patch you
> reverted was just a fix in the ftrace startup test. If something fails
> in the start up test, that something is disabled.  There was a bug in
> the start up test that caused the dynamic ftrace to fail, and thus
> disabling dynamic ftrace. The patch you reverted, was the fix to that
> bug, so you indirectly disabled dynamic ftrace with that revert.
>
> I've been developing a way to get rid of the "ftraced" daemon. Here's a
> big patch to do so against latest git (as of today). Can you go back to
> the original git, apply this patch and see if you can resume again.

I've been following that thread with great interest! Glad to see it's takin=
g=20
shape.

The patch works beautifully. Thanks very much!

Bruce

> After applying this patch you need to do a "chmod +x
> scripts/recordmcount.pl" before compiling.
>
> Thanks,
>
> -- Steve
>
>
> Note: my goodmis.org account is currently offline :-( so I'm sending
> this from my redhat account, where I use TB. I have yet to figure out
> how to send a patch inline correctly with TB, so I'm attaching it.

--nextPart34821353.4hYG5gOAhL
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIC+TCCAvUw
ggJeoAMCAQICECvawsxeeZNuMlZfJi3IhGwwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDUyMDEyMDk0OFoXDTA5MDUyMDEyMDk0
OFowWzEPMA0GA1UEBBMGRHVuY2FuMQ4wDAYDVQQqEwVCcnVjZTEVMBMGA1UEAxMMQnJ1Y2UgRHVu
Y2FuMSEwHwYJKoZIhvcNAQkBFhJid2R1bmNhbkBnbWFpbC5jb20wggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDO1bkRhjwX+pJ4TpMPyCAdx1gbIEra1PLRGn2kwkLvHAxAwuDenLs8v5Su
0fJtYe/TBOkB5r7i191UArkXKFl5W22TfJ0EOsgFNa9H8Sy2u4Kg8YwMNNHb0OR6SBMZgwFGPzi0
t3Fh3YhxACxIOvX2/yf+2kznozvvwwVjd0qqcHm3J7dsrZgMssyRQ1MH5RJng0yRRLCuOk6Zani7
OvnOvzkGLlOkBEP03DBCm2Ub3vuUBiBqxmU//b9pMkGqnSCRCW+2cpBpVqQeg5TVLsLf5PnJ1dnQ
3qzzzBqqy0fP0bfPPkB5TqJbqY6kD0fpFLjDZ4Max4QU2ZXdTXHJPL0RAgMBAAGjLzAtMB0GA1Ud
EQQWMBSBEmJ3ZHVuY2FuQGdtYWlsLmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GB
AFPGdehtL/fiPsN/miK35Jfn3W5rfpdKr7ytdaK9X5Ft/9ECkWb9f268xKMJgZRTB9oU2G4X5iBM
0+xc2fR0be1YnbZroeZBTw6H6cN/UJAHoA07CIM2EVKvWbgvui89BQBly6Fv7JI1KIeYYig+sho3
HgVQ2JqX60wDFIYRSzgAMYICJzCCAiMCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhh
d3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0ECECvawsxeeZNuMlZfJi3IhGwwBwYFKw4DAhqggYswGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwODEzMTgwODQ1WjAjBgkqhkiG9w0BCQQx
FgQUMst2owzJMZw/Gm7hc5UHFam0RV8wLAYJKoZIhvcNAQkPMR8wHTANBglghkgBZQMEAQIFADAM
BggqhkiG9w0DBwUAMAsGCSqGSIb3DQEBAQSCAQDD7Z9FKwqx3bAjLQdPvUuLL7X8JgCBOrn3gDit
BVJWmExY/+UtvI79spCNXiEtRbtLufmxkPCuz7Jl1HgiGgqkbupEg4e9h3BTbDwazSghsoaGcbhz
ykqmqccNDv/VhZxJSKWR9oNdai89LhQl5emeMnsN2fH4SLhMB55iaDM9gWR2lAUA5lsn9XNZawKh
+4YA99dMH6FvKcbVGkGL/y8nIMK5M5v7mKVc95CSc8TVY3l15S1rDpM/958I7o/1IGI3NVCdFxcH
dOYbl8k2ytCepmF3bZGDm+8f4yiPdyNdj/py3XJ9zwTmiWVjBdPRBHEfnPdfOlM/DXfS9PJNTPpn
AAAAAAAA

--nextPart34821353.4hYG5gOAhL--
