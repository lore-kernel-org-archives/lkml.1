Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYADM11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYADM11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYADM0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:26:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:35079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbYADM0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:26:41 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64 early boot code with dynamic table
Date: Fri, 4 Jan 2008 13:23:02 +0100
User-Agent: KMail/1.9.6
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154218.F294E14DDB@wotan.suse.de> <20080104090052.GE28740@elte.hu>
In-Reply-To: <20080104090052.GE28740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041323.02093.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 10:00:52 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > On x86-64 there are several memory allocations before bootmem. To 
> > avoid them stomping on each other they used to be all hard coded in 
> > bad_area(). Replace this with an array that is filled as needed.
> > 
> > This cleans up the code considerably and allows to expand its use.
> 
> this code introduces a number of style errors that make the code harder 
> to read and follow. Please fix them.

I don't see any style errors. Also I didn't realize that white space
was more important than seriously cleaner code now.

-Andi
