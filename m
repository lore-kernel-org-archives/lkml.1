Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZAECUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZAECUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZAECU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:20:28 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:30158 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZAECU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:20:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=p+qfHg3NnCf32BFmP4pM2LQN+oIKqzrkQK1F3NHIdQUrrQ0777d+gDtOkmKO1z6PHm
         3nsWWeTG0pnRqKfGAIDZJ4jmzYYC9Xn8WLjobD54JNzh9HdV8FXyhsWl0Mp5c0ErsYJG
         w9yxk4i3WgBInc85z3jIBPmMMrD8AOxQvJTSQ=
Message-ID: <9929d2390901041820h4cf51e2h3612108c516b6869@mail.gmail.com>
Date: Sun, 4 Jan 2009 18:20:24 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH -net-next 1/4] firmware: convert e100 driver to request_firmware()
Cc: jaswinder@infradead.org, linux.nics@intel.com,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <20090104.160611.252248503.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230626401.24796.22.camel@jaswinder.satnam>
	 <9929d2390812301433pae01ea4g5bfdef6d4d4c7a9c@mail.gmail.com>
	 <20090104.160611.252248503.davem@davemloft.net>
X-Google-Sender-Auth: da56912955cf331a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 4:06 PM, David Miller <davem@davemloft.net> wrote:
> From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
> Date: Tue, 30 Dec 2008 14:33:36 -0800
>
>> Please hold off on committing, until we have had ample time to do some
>> regression testing.  While this patch may have been in linux-next,
>> this is the first we have seen of it.
>>
>> I am concerned that IPMI traffic will be adversely affected by this patch.
>
> Status please?
> --
>

The only testing left to do is to make sure that ICH devices still
work and to make sure the IPMI traffic is not affected by this patch.
All other testing looks good.  I am sorry that I have been slow to
give status, the holiday's have put a strain on available resources.

-- 
Cheers,
Jeff
