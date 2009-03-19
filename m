Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZCSNgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZCSNgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZCSNgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:36:12 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:45998 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751671AbZCSNgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:36:11 -0400
Subject: Re: High contention on the sk_buff_head.lock
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vernon Mauery <vernux@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1237467559.6926.31.camel@hermosa>
References: <49C12E64.1000301@us.ibm.com> <87prge1rhu.fsf@basil.nowhere.org>
	 <1237467559.6926.31.camel@hermosa>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 19 Mar 2009 07:36:01 -0600
Message-Id: <1237469761.6926.47.camel@hermosa>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 06:59 -0600, Peter W. Morreale wrote:
> On Wed, 2009-03-18 at 21:54 +0100, Andi Kleen wrote:
> > Vernon Mauery <vernux@us.ibm.com> writes:
> > >
> 
> > 
> > But then again I'm not sure it's  worth it if the problem only
> > happens in out of tree RT.
> > 
> 
> Heh.  That darn bastard child again, eh?  :-)
> 
> 
> Recall that adaptive spin,developed in RT, is now in mainline. 
> 

Err..  correction... *about* to be in mainline.   Only point I'm making
is that RT does implicitly, if not explicitly, contributes to mainline.
Its not a one-way street. 

Best,
-PWM

> Best,
> -PWM
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

