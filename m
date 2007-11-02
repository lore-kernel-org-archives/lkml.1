Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXKBRwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXKBRwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXKBRwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:52:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:19718 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbXKBRw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cSXNv9N9SV5KROlQqeGRjj51SjE+OexjVJ+WWTE7OwHSBY8eJKl7WKTVdyOFXSZyC8BkpBmMIqS5kaAALKrBul4T2Hnr4AWXqHg0xvuBLU4DYz7u7XWrcV/4yHJLpbgNayUnKa9MsjVNw4VsI3lS/7qnDx5FvY3Ou48+9n7eD+s=
Message-ID: <e9e943910711021052j4b5366c4u8b3ae87080e8b310@mail.gmail.com>
Date: Fri, 2 Nov 2007 17:52:25 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: patch remove-broken-ptrace-special-case-code-from-file-mapping.patch queued to -stable tree
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>, stable@kernel.org,
       npiggin@suse.de
In-Reply-To: <472B59CC.9030206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071102162222.EC46D14540CB@imap.suse.de>
	 <alpine.LFD.0.999.0711020945330.3342@woody.linux-foundation.org>
	 <20071102165816.GA16493@suse.de> <472B59CC.9030206@redhat.com>
X-Google-Sender-Auth: ac63b9ac78618b00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2007, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 11/02/2007 12:58 PM, Greg KH wrote:
> > Unless Nick really objects, and then I'll drop yours and use his, but I
> > don't think that Duane verified that his patch fixed the issue.
> >
>
> I put Nick's in Fedora, so it had better work...  ;)

I've tested both patches, and they both fix the problem. So no
worries, either way :)

As Linus said, his patch does change the behaviour. I'm not qualified
to judge how risky that is, however I think that the change is an
improvement. In fact in my original bug report I suggested the old
behaviour could be considered buggy and the new behaviour might be
preferable.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
