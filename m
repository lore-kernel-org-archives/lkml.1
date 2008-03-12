Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbYCLKdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbYCLKdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYCLKc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:32:56 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38222 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbYCLKcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:32:55 -0400
Date: Wed, 12 Mar 2008 11:32:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Fred ." <eldmannen@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
In-Reply-To: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Fred . wrote:

> Sometimes the keys get "stuck" and it keeps on repeating the button all 
> the time. It often happen when I play games, that it repeats one of the 
> arrow keys.
> Now this is a problem that lots of people have experienced.
> I've experienced it with other kernels too.

Very probably this is due to broken way how X themselves implement 
auto-repeat, instead of using kernel-provided auto-repeat functionality. I 
guess you are not able to reproduce this problem in the console, but only 
X, right?

> Someone said this was a problem with dynticks, but I don't know.

AFAIK it's a problem with X being confused by scheduler behavior (which is 
not necessarily wrong).

-- 
Jiri Kosina
SUSE Labs

