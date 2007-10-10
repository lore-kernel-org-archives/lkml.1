Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXJJNTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXJJNTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXJJNSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:18:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:56836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXJJNSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:18:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: x86_64 : kernel initial decompression hangs on vmware
Date: Wed, 10 Oct 2007 15:18:42 +0200
User-Agent: KMail/1.9.6
Cc: Zachary Amsden <zach@vmware.com>, Avi Kivity <avi@argo.co.il>,
       lkml <linux-kernel@vger.kernel.org>, david-g@263.net
References: <392001863.28140@ustc.edu.cn>
In-Reply-To: <392001863.28140@ustc.edu.cn>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710101518.42830.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 09:37:39 Fengguang Wu wrote:

> One of my friends' vmware "hangs" 

It should just be a little slow. VMware seems to do something fishy
here -- KVM or Xen using VT don't have this issue.

> on booting Linux 2.6.23, and then get 
> it to work by applying your patch at http://lkml.org/lkml/2007/8/4/72.

The patch is already in 2.6.23; it was just missing in .22. Perhaps
your friend confused those two.

-Andi
