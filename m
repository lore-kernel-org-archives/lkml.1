Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYCXGyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYCXGyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 02:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYCXGyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 02:54:03 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54088 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbYCXGyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 02:54:01 -0400
Message-Id: <1206341640.31427.1243929483@webmail.messagingengine.com>
X-Sasl-Enc: RCYCOznM+TQ6OLAfZrdngBR8b42aC883O2SWDGZAWi2I 1206341640
From: "Kai" <epimetreus@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
   <87tziw7p3b.fsf@basil.nowhere.org>
Subject: Re: Serious performance regression in Wine applications and Linux
   2.6.24.*
In-Reply-To: <87tziw7p3b.fsf@basil.nowhere.org>
Date: Sun, 23 Mar 2008 23:54:00 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Mar 2008 04:55:36 +0100, "Andi Kleen" <andi@firstfloor.org> said:
> "Kai" <epimetreus@fastmail.fm> writes:
> 
> > Originally, it was just about everything -- Wine itself, and most any
> > app I tried to run with it.
> > 
> > In my most recent tests, however, it only seems to affect Age of Wonders
> > II and Age of Wonders Shadow Magic, which use very similar engines.
> 
> A simple test if the scheduler is likely to blame would be to compare
> context switch rates between the different kernel versions who show
> differing performance. You can do that with running "vmstat 1" in
> parallel and checking the "cs" column.
> 
> Another powerful but quite slow method if you can easily reproduce it
> would be a full git bisect. That would identify exactly which change
> introduced your problem.
> 
> -Andi

Can you explain more clearly what you mean with vmstat?

Also, I'd like to find a way to feasibly do the git bisect (I assume you
basically mean testing against every change in sequence since .23), but
I'd like some advice on how to do this, and how to do it reasonably
expeditiously.
