Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZB1Wa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZB1Wa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZB1WaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:30:19 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:34060 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbZB1WaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:30:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O3tHThVvcrioCNoabPVgffkolvPVfmKL1ob7RaeJKde0AkpJGdFkk6klXVqy11yFY+
         g8PdWtKndfOui/werc99AWdZyEwCM8ydlqHKz4dclL4a+jgL2uRg12UP0R4lgLRBF0gL
         w/0tsVcY66en8GWbtW5UgcLHfwGXKF0fzI94k=
Date: Sat, 28 Feb 2009 14:30:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [PATCH] Input notifier support
Message-ID: <20090228223004.GB16208@dtor-d630.eng.vmware.com>
References: <20090225044730.GA9106@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225044730.GA9106@july>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Wed, Feb 25, 2009 at 01:47:30PM +0900, Kyungmin Park wrote:
> Some hardware doesn't connected with key button and led. In this case
> key should be connected with led by software. Of course each application
> can control it however it's too big burden to application programmer.
> 
> So add input notifier and then use it at other frameworks such as led.
> Of course, other input device can use this one.
> 
> Any commnets are welcome.
> 

I don't think we need to do the notifier route. It is very easy to add
another input handler in style of rfkill-input or apm-power that would
listen to events from all ungrabbed input devices and act accordingly.
Your LED trigger example should work very well if implemented as another
input handler.

Thanks.

-- 
Dmitry
