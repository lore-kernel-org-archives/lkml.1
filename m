Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYGQC1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYGQC1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYGQC04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:26:56 -0400
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:52400 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752779AbYGQC0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:26:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=rSRcHuoQDKptPNMFIt6Flv/92QXe8dmPoaYs/b2nBxnL5/CxTfOBXRZgNMzhjclSkwoj8yJT7mtOdSQB4EGIKBjSd7TqJYuaQtvFm96JSeFFjUyPXwHsO0l6VTF81g0Y;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull ACPI updates
Date: Wed, 16 Jul 2008 19:26:45 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20080716214516.GA10777@basil.nowhere.org> <alpine.LFD.1.10.0807161728560.2835@woody.linux-foundation.org> <alpine.LFD.1.10.0807161751490.2959@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807161751490.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161926.45975.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 5:53:55 pm Linus Torvalds wrote:
> On Wed, 16 Jul 2008, Linus Torvalds wrote:
> > Well, I haven't actually seen Len's original tree, so maybe the stuff
> > Andi pushed was just the stuff he had queued up independently. I guess I
> > shouldn't judge before I'm sure.
>
> No, he rebased it - the three commits you shared are now separate ones.

Well, I could have misunderstood what we talked about; I guess I just assumed 
Andi & I would chat before sending out our pull requests.  I'll be sure to 
coordinate better next time.

> Most of the conflicts seem to have been due tot he x86 tree changes
> though. But it seems I didn't mess up too much: at least the result booted
> for me without complaints. So I pushed out my resolution.
>
> Jesse, can you please double-check it?

Just looked, seems fine.  I'd pat you on the head to reassure you about it, 
but my arms aren't quite long enough...

I'll dig around some more for git best practices too.  Based on what I've seen 
of the x86 tree I don't have nearly enough branches (though on the plus side, 
I almost never rebase since I don't want to hose any downstream users, and I 
don't merge from your tree until after you've pulled to avoid cluttering up 
the log).

Thanks,
Jesse
