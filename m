Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbYDQRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbYDQRNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYDQRNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:13:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:42224 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760660AbYDQRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AEI0X6Fy4J2LwKNmD3JhkX6JmV4loeWCV9U7BbqwqGXzC39J1q9S2zzVvx/U65xqGEoztjdbEsKmqGdfDf9teVqRHORe/Fb/X2GXYaAotRQcTzDkTFJD0nmZIP2IxC/vI6ulqBHvNh+OqS1CAX9qY/HxZ6PaB7sCopAKfLuj83Q=
Date: Thu, 17 Apr 2008 13:13:28 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/29] drivers: use non-racy method for proc entries
	creation
Message-ID: <20080417131211.ZZRA012@mailhub.coreip.homeip.net>
References: <1207653508.7171.18.camel@iris.sw.ru> <1207653576-12640-29-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207653576-12640-29-git-send-email-den@openvz.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 03:19:36PM +0400, Denis V. Lunev wrote:
> Use proc_create()/proc_create_data() to make sure that ->proc_fops and
> ->data be setup before gluing PDE to main tree.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>

No objections to the input change.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
