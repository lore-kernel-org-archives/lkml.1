Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYHYRJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYHYRJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYHYRIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:08:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:11821 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYHYRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JXYro8o7dzIOy+6HRw1J5i5rpXkT6CjDbuj5HoMm43MDLJA8I37NLhOVFxBx+4+xEa
         1Z08qT/phEcKFl8LayvJPBCRdLSdSJWkc90l7pdWJ78plLxWVUnsqPOcrq976fybGlgS
         Pf20AN3cOx+vJo6kZIXzpv4U0ufJF8Xfo8eL0=
Message-ID: <86802c440808251008n18039d05ld2c83bedabdb4a36@mail.gmail.com>
Date: Mon, 25 Aug 2008 10:08:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Bernhard Walle" <bwalle@suse.de>,
       "Vivek Goyal" <vgoyal@redhat.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <m1r68dmdd1.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
	 <m14p59ztz1.fsf@frodo.ebiederm.org> <20080825071709.GB26048@elte.hu>
	 <m1r68dmdd1.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 6:30 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Why does pci_find_parent_resource fail?

it doesn't fail, it got [0, -1ULL].

because that device 00:14.0 is on bus0. and that is one HT chain system,

YH
