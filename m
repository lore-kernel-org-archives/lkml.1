Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbYHLGMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbYHLGMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYHLGLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:11:53 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56425 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYHLGLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:11:53 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/1] iwlwifi: fix printk newlines
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218519496.3107.235.camel@debian.sh.intel.com>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
	 <1218502555.25524.22.camel@californication>
	 <1218504137.3107.201.camel@debian.sh.intel.com>
	 <1218513565.25524.31.camel@californication>
	 <1218519496.3107.235.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 08:11:58 +0200
Message-Id: <1218521518.25524.37.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yi,

> > > We should give the users more control to the style I think.
> > 
> > what kind of control do you expect? If you need two lines of debug or
> > error output, call IWL_ERROR twice. This will also result in the
> > KERN_ERR is set and not forgotten since that has to follow the
> > newline.
> 
> I thought sometimes we might not need a new line between two IWL_ERRORs.
> But your KERN_ERR garbaging the output in this case is correct. I think
> when we wrote the macro, we just follow the style of dev_info() ...
> dev_emerg() macros. Do you know why there is not a new line for them by
> default?

I have no idea. Maybe because they are close to printk. I always put the
newline into my macros.

Regards

Marcel


