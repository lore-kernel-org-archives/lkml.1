Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYA1Oh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYA1Oh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYA1Ohv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:37:51 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2637 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYA1Ohv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:37:51 -0500
Date: Mon, 28 Jan 2008 14:38:46 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: add filename in the summary
Message-ID: <20080128143846.GH12910@shadowen.org>
References: <20080114232339.2c018647@paolo-desktop> <4d8e3fd30801220520p14dbf5aau874d1df86415359a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801220520p14dbf5aau874d1df86415359a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 02:20:48PM +0100, Paolo Ciarrocchi wrote:
> On Jan 14, 2008 11:23 PM, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> > Add a filename option (default to 0)
> > in order to get the following summary output:
> > ./scripts/checkpatch.pl --filename --file ./arch/sparc/kernel/apc.c
> > ...
> > ...
> > ...
> > ./arch/sparc/kernel/apc.c --> total: 18 errors, 3 warnings, 186 lines checked

Ok, I've applied a heavily modified version of this to match the current
code.  The option is now --summary-file to prevent confusion between it
and the --file option.

> Hi Andy,
> do you plan to document all the command line options that checkpatch
> is currently accepting?

Most of the undocumented options are either used in testing or are for
uncommon usage.  Some work does need doing on the usage tho.

-apw
