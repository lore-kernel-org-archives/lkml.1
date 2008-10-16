Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYJPQWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYJPQWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYJPQWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:22:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:10964 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYJPQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JLhwvaJfpVFUCZBbNpucvmkFnCRlvpASOB5GlzHxpkPM+H2hrNq4J+lDBwoZ6Unnvh
         yX96Cl+mriTgvyp2D7gbIwRa0pHHg4jkyf8ylVKaYmNLGVPZjdoDRdcz3FzqeY1oz526
         c2SfMq12KTlRVPRx7fev6OndEJUQu5v3lxqZk=
Message-ID: <4807377b0810160922q70fdcc95u36d937f29c473f14@mail.gmail.com>
Date: Thu, 16 Oct 2008 09:22:15 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "David Miller" <davem@davemloft.net>,
       "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Subject: Re: powerpc allmodconfig
Cc: brice@myri.com, dan.j.williams@intel.com, akpm@linux-foundation.org,
       tiwai@suse.de, linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com, marek.vasut@gmail.com,
       dwmw2@infradead.org, mark.fasheh@oracle.com, ralf@linux-mips.org,
       mchehab@infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jesse.brandeburg@intel.com
In-Reply-To: <20081015.235844.206136521.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081015.220247.262683261.davem@davemloft.net>
	 <1224137292.26782.5.camel@dwillia2-linux.ch.intel.com>
	 <48F6E54C.5010207@myri.com>
	 <20081015.235844.206136521.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 11:58 PM, David Miller <davem@davemloft.net> wrote:
>> There's already a completely different fix queued in netdev patchworks
>> (for myri10ge only right now, to be duplicated for Intel drivers). The
>> idea is to stop having almost-unrelated drivers select each other
>> directly, let people select which drivers they really want, and have
>> Kconfig handle modules/builtin-stuff correctly. See
>> http://patchwork.ozlabs.org/patch/4506/
>
> Right, my plan was to duplicate this for the other drivers.

The work is already done for ixgbe and igb, and we have it in testing.
 It should be in your inbox today or tomorrow.
