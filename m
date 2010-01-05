Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246Ab0AEMwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0AEMwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402Ab0AEMwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:52:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab0AEMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:52:41 -0500
Date: Tue, 5 Jan 2010 13:52:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com,
       Artem Bityutskiy <dedekind@infradead.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100105125234.GD1778@basil.fritz.box>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com> <87eim4dbzw.fsf@basil.nowhere.org> <20100105122101.GR13802@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105122101.GR13802@discord.disaster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also it would seem cleaner to have it in a own file.
> 
> That might make sense if we had a large number of generic sort
> functions and it was difficult to tell the code apart, but we've
> only got 2 right now....

I was more thinking of the case that it can be easily made a lib-y
and then eliminated by the linker on non modular kernels if not needed
(unfortunately that would require putting the EXPORT_SYMBOL somewhere else)

-Andi
