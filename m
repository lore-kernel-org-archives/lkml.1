Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbXFRWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbXFRWB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762481AbXFRWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:01:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762055AbXFRWBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:01:17 -0400
Message-ID: <46770091.2080109@redhat.com>
Date: Mon, 18 Jun 2007 16:00:49 -0600
From: Brendan Conoboy <blc@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: david@lang.hm
CC: Wakko Warner <wakko@animx.eu.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com> <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm> <20070618214633.GA15468@animx.eu.org> <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> yes, I'm useing promise drive shelves, I have them configured to export 
> the 15 drives as 15 LUNs on a single ID.

Well, that would account for it.  Your bus is very, very saturated.  If 
all your drives are active, you can't get more than ~7MB/s per disk 
under perfect conditions.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
