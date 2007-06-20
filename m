Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXFTQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXFTQ7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXFTQ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:59:32 -0400
Received: from dsl092-020-029.wdc2.dsl.speakeasy.net ([66.92.20.29]:55049 "EHLO
	mailer.progressive-comp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755283AbXFTQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:59:31 -0400
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 12:59:31 EDT
Date: Wed, 20 Jun 2007 12:38:48 -0400 (EDT)
From: Hank Leininger <hlein@progressive-comp.com>
X-X-Sender: hlein@marklar.spinoli.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: =?X-UNKNOWN?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Request for Linux Kernel Mailing List archives
In-Reply-To: <46794E5B.6070506@zytor.com>
Message-ID: <Pine.LNX.4.64.0706201210330.18771@marklar.spinoli.org>
References: <467949CC.9090405@zytor.com> <20070620155231.GA18644@atjola.homenet>
 <46794E5B.6070506@zytor.com>
X-Marks-The: Spot
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168433674-1922559663-1182356843=:18771"
Content-ID: <Pine.LNX.4.64.0706201227350.18771@marklar.spinoli.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--168433674-1922559663-1182356843=:18771
Content-Type: TEXT/PLAIN; CHARSET=X-UNKNOWN; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0706201227351.18771@marklar.spinoli.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wed, 20 Jun 2007, H. Peter Anvin wrote:

> Bj=F6rn Steinbrink wrote:
>>
>> marc.info supports that.
>>
>> http://marc.info/?i=3D467949CC.9090405@zytor.com
>
> Excellent!  Didn't see that documented anywhere.

=3D)

You're right, it's not really.  In fact very little is documented.
You'd have to discover it -- in the message view, the Message-ID is
actually a self-referential link using the above syntax.

A few relevant points:
- - Such links never actually show you the corresponding message.  Instead:
   - If the message-id is unique, you are sent a 302 redirect to the
     message using the normal MARC message URL (l=3Dfoo&msgid=3D123)
   - If the message-id is not unique (such as crossposting, or deliberate
     attempts to cause collisions) you'll be presented with a list of
     messages, showing date, subject, author, and listname, to choose from.
- - MARC doesn't currently touch message bodies for spam-obfuscation
   purposes, but it does for headers, specifically From: and Message-ID:.
   When MARC generates message-id-based links, they are obfuscated.
   But it can read in links formed either way.  So, if you copy/paste the
   target of a Message-ID: link out of MARC, it will look slightly
   different than if you just made your own http://marc.info/?i=3Dwhat@not,
   but either form will work.
- - We don't use < > surrounding the message-id, but again, will accept
   URLs formed either way.
- - We don't have Message-ID's for messages added before Dec, 2003.

Please feel free to ping me (offlist) with questions/concerns, hopefully
I will manage to respond :-P

Thanks,

Hank
-----BEGIN PGP SIGNATURE-----

iD8DBQFGeVgYqP26fHCT+PMRAsFHAJ9G2v+vrQ4g7VUAWEr1+Tb3dHDi3wCfRfho
sCYaEfLf9cJjGZtgpsCAPII=3D
=3DPpNt
-----END PGP SIGNATURE-----
--168433674-1922559663-1182356843=:18771--
