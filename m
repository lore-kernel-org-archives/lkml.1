Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZAUW6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZAUW6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZAUW6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:58:12 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:25777 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbZAUW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:58:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJbhdkl5LAUp/2dsb2JhbADNcIVz
X-IronPort-AV: E=Sophos;i="4.37,303,1231075800"; 
   d="scan'208";a="272605167"
Date: Thu, 22 Jan 2009 09:58:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090121225800.GO10158@disturbed>
Mail-Followup-To: Jacek Luczak <difrost.kernel@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	LKML <linux-kernel@vger.kernel.org>,
	xfs mailing list <xfs@oss.sgi.com>
References: <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com> <20090120140514.GA2976@infradead.org> <4975DE45.7050004@gmail.com> <20090121040512.GK10158@disturbed> <4976E524.1050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976E524.1050607@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:04:36AM +0100, Jacek Luczak wrote:
> Dave Chinner pisze:
> > Please try the patch I posted this morning - it fixes the problem
> > properly and shouldn't have this side effect.
> 
> Your patch work for me. I've made also some tests a'la one proposed by
> Christoph, here also everything works. Good work guys!

Thanks for testing the fix, Jacek. I'll get it pushed upstream
now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
