Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbXJMLqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbXJMLqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 07:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXJMLqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 07:46:01 -0400
Received: from smtp125.plus.mail.mud.yahoo.com ([209.191.106.156]:22559 "HELO
	smtp125.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752890AbXJMLqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 07:46:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=naPU8r5do0HV1zoTCj/4AGVqKWfMJfyBeFGRTJJ2nDlQZuYlD0YUEyOy6D6xiGp61d66ZO6tYIA3Ov62w+Otrt12zqi50mj5I29JGmWOssCeptq1rY410hENsRZcN5cpS5WmWMytLin0LxhSv/MM9NwuLtMi8uhkgoZQlvWXq9c=  ;
X-YMail-OSG: ue7LHgkVM1ldgKkvbIupDn4Tfa4wnNO60Ngb.go1BtxdC1iYj7.63iUVbBc8WPAMVZyFY7cJ7PjGByjPmBggggmOcYHYx6KdNYtzRCH42TJnkt9JEYE-
Date: Sat, 13 Oct 2007 13:45:50 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: -mm merge plans for 2.6.24
Message-ID: <20071013114549.GA10875@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <20071013084455.GA5656@gollum.tnic> <20071013015252.3f916ef1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071013015252.3f916ef1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 01:52:52AM -0700, Andrew Morton wrote:
> On Sat, 13 Oct 2007 10:44:55 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:
> 
> > can you please add http://lkml.org/lkml/2007/7/30/98 also to the misc-queue for
> > the warning still persists and the patch is good to go as is (against current git
> > v2.6.23-2840-g752097c, for example) albeit with a little fuzziness.
> 
> I got completely fed up with maintaining that patch against ongoing churn
> frenzy in Greg's trees so I dropped it.
> 
> If/when things settle down in that area someone will need to redo the
> patch.

/me wondering: what if you pass it on upstream to Linus, since:
1. it applies cleanly now
2. is pretty trivial
and forget it about it forever :). It seems the place this
patch touches is the only place where kobject_* and sysfs_create_* etc. error
codes are not being handled in contrast to all those functions which have been declared
__must_check?

-- 
Regards/Gruﬂ,
    Boris.
