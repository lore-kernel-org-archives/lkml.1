Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbYH3ElV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbYH3ElV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 00:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYH3ElL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 00:41:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:18581 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYH3ElK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 00:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JteM/H5Esz/jiuw+2mYeR2ZMmCN7gD89HpOSvX9SYZwZn8PaHWn9VEyv/XtyidOK6P
         ce9wq/UM8hkhCsEdeWcSqWUAiaxYine+LyoZhvyWp4cAGl4QNoYCKDFV27dGiUY1kVLM
         DxkZX3N/1xBOeAje3ww3TcDyEDP6YI8jVErFA=
Date: Sat, 30 Aug 2008 08:42:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: kobject leak in next-20080829
Message-ID: <20080830044246.GA26435@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	size-32: 3511 kvasprintf+0x57/0x90
	size-64: 3059 kobject_create+0x1c/0x40

These two buddies increase after every "modprobe; rmmod" sequence.

