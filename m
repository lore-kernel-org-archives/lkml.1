Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZCVTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZCVTbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZCVT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:28:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:37566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbZCVT2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:28:52 -0400
Subject: Re: Warning: File `include/config/auto.conf' has modification time
 1.9e+04 s in the future
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090322190622.GA5362@uranus.ravnborg.org>
References: <1237667676.17548.3.camel@localhost.localdomain>
	 <20090322190622.GA5362@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 00:58:18 +0530
Message-Id: <1237750098.5417.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Sun, 2009-03-22 at 20:06 +0100, Sam Ravnborg wrote:
> I have checked the source code in kconfig where we minupulate auto.conf.
> We do a simple 
> 
> fopen(".tmpconfig", "w");
> write a lot
> fclose()
> rename(".tmpconfig", "auto.conf");
> 
> So nothing suspicious that involves changing the date of the file.
> 
> I expect you have to locate the issue locally if it happens again.
> 

OK, it is a dual boot machine may be Windows screws it, if I face
similar problem again I will let you know.

> [And it was late in night too :-) ]
> 

hehe :-)

Thanks,

--
JSR

