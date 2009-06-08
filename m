Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZFHG14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZFHG14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZFHG1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:27:48 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40060 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZFHG1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:27:47 -0400
Date: Mon, 8 Jun 2009 08:30:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: eko suwarsono <ekoswr76@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux Bridge Module
Message-ID: <20090608063004.GA22910@uranus.ravnborg.org>
References: <6d6e77f50906072256m31c17ae8j5c4634ab5ad44761@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d6e77f50906072256m31c17ae8j5c4634ab5ad44761@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 01:56:14PM +0800, eko suwarsono wrote:
> Hi all
> 
> I'm newbies on this mailing list, so please advise me if i asking the
> wrong question.
> I had plan to add bridge module (bridge.ko) on embedded system which i
> got from vendor. the embedded linux system is using Debian sarge 1.3
> and has linux kernel 2.6.20.4 with gcc 3.4.4. the operating system is
> installed on CF card
> 
> i tried to compile the linux kernel 2.6.20.4 using gcc 3.4.4 on
> another system which using ubuntu feisty to get the bridge.ko module.
> and then copying the module into the embedded system.
> 
> the problem here that the insmod complaining : -1 invalid module format.
> 
> can somebody help me on this? many thanks for all

Do you use a cross compiler that match your target?
Does file bridge.ko detect the correct architecture?
Can you build and load other modules?

If you can answer yes to the baove try posting the Makefile you use.
Many external modules uses a 2.4 style Makefile which does not work with kernel 2.6.

	Sam
