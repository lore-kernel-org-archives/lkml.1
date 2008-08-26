Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYHZLQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYHZLQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYHZLPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:15:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:19509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYHZLPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gko8lqT2s8jB8q7w9+/OcsQ/M7j2lNeIJAQEQ1Z5u9sLNlSqkMRJMgO/JUObG7fFqr
         zo0jTh6px5/WaIwRzHB1EKsTogQUCsx5zj84IJnvnHcEqHnZS8v83a3gv/c/cCCI3wDe
         gacLHB3uT2pff8OJxbOHQoR9wd/Ihflv3zWMA=
Date: Tue, 26 Aug 2008 11:15:45 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080826111545.GD2609@ff.dom.local>
References: <20080826095126.GA2609@ff.dom.local> <200808261329.53741.denys@visp.net.lb> <20080826104717.GB2609@ff.dom.local> <200808261349.09820.denys@visp.net.lb> <20080826110746.GC2609@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826110746.GC2609@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 11:07:46AM +0000, Jarek Poplawski wrote:
> On Tue, Aug 26, 2008 at 01:49:09PM +0300, Denys Fedoryshchenko wrote:
...
> > Maybe it can be optional, and enabled via kernel parameter and /sys , so it 
> > can be useful in case of crashes when TSC used and when timer is too slow.
> > Because it is not so useful just to disable hrtimers completely, if you need 
> > them for some other task...
> 
> Maybe it could be enough to use current parameters like: "highres=off"
> according to Documentation/kernel-parameters.txt?

Hmm.. it isn't actually answer to your question, sorry. As I said
before I think we need to have more people interested in using such
additional options, and btw. I understood from your message that 
disabling htb didn't solve the problem?

Jarek P.
