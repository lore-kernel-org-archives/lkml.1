Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbXIZPhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbXIZPhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbXIZPho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:37:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbXIZPhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:37:43 -0400
Date: Wed, 26 Sep 2007 08:37:05 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Module use count must be updated as bridges are
 created/destroyed
Message-ID: <20070926083705.6bc65ea5@fujitsu-loaner>
In-Reply-To: <46FA2C17.76E4.0078.0@novell.com>
References: <46FA2C17.76E4.0078.0@novell.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 08:53:27 +0100
"Jan Beulich" <jbeulich@novell.com> wrote:

> Otherwise 'modprobe -r' on a module having a dependency on bridge will
> implicitly unload bridge, bringing down all connectivity that was
> using bridges.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>

No, network devices don't do reference counting.
What is the dependency? Where is the source of the module interacting
with the  bridge?
