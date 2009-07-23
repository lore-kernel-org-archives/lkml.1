Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZGWIyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZGWIyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZGWIyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:54:03 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.32]:44690 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZGWIyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:54:03 -0400
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com> <cone.1247683003.40459.21332.1000@deskpiie> <20090723082904.GE3997@dtor-d630.eng.vmware.com>
Message-ID: <cone.1248339143.133822.15136.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Date: Thu, 23 Jul 2009 10:52:23 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Dmitry Torokhov writes:

> On Wed, Jul 15, 2009 at 08:36:43PM +0200, Peter Feuerer wrote:
>> Works fine here, thanks!
>>
>> Acked-by: Peter Feuerer <peter@piie.net>
> 
> Umm, did you test suspend-to-disk? As far as I understand the new
> suspend() and resume() methods are onluy used for S2R and for S2D you need
> to use freeze() and thaw().

No, I didn't test S2D, will have a look at this issue. Thanks for pointing 
out!

--peter
