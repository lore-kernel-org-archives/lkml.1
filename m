Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYEaQyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYEaQyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYEaQy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:54:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:22606 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYEaQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K+KaOtkKlQw3iIqa8z5Z/ypxC6Xrqy6r03sB53YxQ3S+YYj1VrA7bmJs3e/FPZw0XCeV58wLYt7NS8K7B9zWMcXcjMOrc0OxVbVeX3xKNwZaL4Ju757dXlY43HLgQMrNHHVmO7IbWGy8JFy98PxE1l+s4nyseIGiIkLcgczOkdU=
Message-ID: <69e28c910805310954s6c478001h837415a6a63d26f0@mail.gmail.com>
Date: Sat, 31 May 2008 18:54:24 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212252522.2766.8.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <1212252522.2766.8.camel@rd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 6:48 PM, Pavel Roskin <proski@gnu.org> wrote:
> It's strange that other drivers (b43legacy, ath5k) use
> info->control.hw_key->hw_key_idx under the same conditions (see how
> use_encryption is calculated), but don't have any problems on the same
> network (but I need to recheck).

Hmm... does ath5k use hardware crypto? B43 does (but not with
nohwcrypt - and that appears to be a valid workaround), b43legacy
doesn't AFAIK.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
