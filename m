Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYEPVW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYEPVW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYEPVWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:22:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:63103 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYEPVWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wrRipyaESDgfjpO5YbGPZ2hASl4QLuwY5IjqESt712uR+X02RWeJdp4Ev9zVFI9TFTLZ08YG45Nmn26TPw1wNFHzBJCvjyTbAt5RcOEF6i5JghVgMDglkqqgefS+At4cm4zgbvMfkaINdty18TairUcb2/yLwdHdckOUcdyhQ0o=
Date: Sat, 17 May 2008 02:17:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: 2.6.26-rc2-mm1: high speed something
Message-ID: <20080516221749.GA3808@martell.zuzino.mipt.ru>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  linux-next.patch

That's terse. ;-)

Who is responsible for something called "Option High Speed Mobile
Devices"?

It's using create_proc_read_entry() interface, so should be switched
to seq_files before merging.

And "procfs" module parameter is plain stupid, sorry.

