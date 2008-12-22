Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYLVK5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYLVK5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYLVK5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:57:41 -0500
Received: from smtp4.netcologne.de ([194.8.194.137]:57546 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYLVK5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:57:40 -0500
Date: Mon, 22 Dec 2008 11:57:38 +0100
From: Max Kellermann <max@duempel.org>
To: Jan Niehusmann <jan@gondor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: KVM guest lockup
Message-ID: <20081222105738.GA27409@squirrel.roonstrasse.net>
Mail-Followup-To: Jan Niehusmann <jan@gondor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20081219174401.GA2730@squirrel.roonstrasse.net> <20081221115538.GA25958@x61s.gondor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221115538.GA25958@x61s.gondor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/12/21 12:55, Jan Niehusmann <jan@gondor.com> wrote:
> As I observed such behaviour only when the host has frequency
> scaling activated: Could it be that in this case,
> clocksource_read(clock) on the guest is misbehaving?

Indeed, the host had governor=ondemand.  After the switch to
"performance", the guest seems to run stable.

So this is a bug in the guest kernel, by making wrong assumptions on
the clock values retrieved from the host, right?

Max
