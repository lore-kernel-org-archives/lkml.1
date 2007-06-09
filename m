Return-Path: <linux-kernel-owner+w=401wt.eu-S1032633AbXFIAIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032633AbXFIAIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968638AbXFIAI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:08:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39567 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966336AbXFIAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:08:25 -0400
Date: Fri, 8 Jun 2007 17:08:27 -0700
From: Greg KH <greg@kroah.com>
To: dougthompson@xmission.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
Message-ID: <20070609000827.GA17624@kroah.com>
References: <46698796.gjBYQfxJb/tGpgvg%dougthompson@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46698796.gjBYQfxJb/tGpgvg%dougthompson@xmission.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 10:45:10AM -0600, dougthompson@xmission.com wrote:
> From:	Douglas Thompson <dougthompson@xmission.com>
> 
> pci_ids.h needs two of the AMD NB device-ids namely,
> Addressmap and the Memory Controller devices

Does any kernel driver need this?  We're trying to only include things
in the pci_ids.h file that are needed in more than one file to cut down
on the churn here for unnecessary ids.

thanks,

greg k-h
