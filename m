Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZCWOrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZCWOrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZCWOrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:47:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:45082 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbZCWOrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZwqRC/yBU2Uy6Gud4zYJqI5s6NwafscdpKZ/FwIod7mfEjrF4ktuR78WLTXMGO9UvV
         5Md2nAt6UUuMsgJMJxLwbDAHI2A8V8j9cbdOaTKgxzNW9dxqMGiViCZ+fAnwQnlCA6Qb
         6HkNPBKSGTH4ZKQopSei6kMYu+LxuqjI6krus=
MIME-Version: 1.0
In-Reply-To: <1237816050.3833.20.camel@T60p>
References: <1237575285.26159.2.camel@T60p>
	 <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	 <1237578912.26159.13.camel@T60p>
	 <412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
	 <1237579738.26159.16.camel@T60p>
	 <412bdbff0903201314r5105d373ofe6614ee08431d4b@mail.gmail.com>
	 <1237816050.3833.20.camel@T60p>
Date: Mon, 23 Mar 2009 10:47:21 -0400
Message-ID: <412bdbff0903230747i1ebc4487x2636369e6b20ce8f@mail.gmail.com>
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U 
	grabbers
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mikhail Jiline <misha@epiphan.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 9:47 AM, Mikhail Jiline <misha@epiphan.com> wrote:
> Here is the output from the version with em28xx_i2c_hash hint. Update patch is below.
<snip>

Ok, that looks better.  You should no longer need the "card=" line
with that patch.

Did you verify that both video inputs were working as expected?  Also,
did you confirm the audio support works?  If so, please remove the
"valid        = EM28XX_BOARD_NOT_VALIDATED", submit a final patch, and
I will check it in.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
