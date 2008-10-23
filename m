Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYJWIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYJWIc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYJWIch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:32:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:52558 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYJWIcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CkLHhRJtGY4SQLoe9rcSji/ZdvoR/IZHd605uTQT2+PcIpB2kX0Z0qVN+nrgSwz32w
         sGf9wpnJDo0DVp5Xq6DMqRVdV3P8XSlcPHgh1phcVR/v4+pU4W1iXdhLg3YBW9X+RBKe
         VoVLJZsYDGva5TtFY/OnUfcGqLLlORQ5YOLEI=
Date: Thu, 23 Oct 2008 12:35:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: use WARN() rather than printk+backtrace
Message-ID: <20081023083547.GA32124@x200.localdomain>
References: <20081021064612.4578920c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021064612.4578920c@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 06:46:12AM -0700, Arjan van de Ven wrote:
> -			printk(KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
> +			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",

Applied to proc.git

As a side note, seeing WARN twice on this line is depressing, and people
use WARN(, KERN_ERR);

I mean, how hard is to get something conceptually simple as warning right?
