Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800Ab0AQMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0AQMk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762Ab0AQMk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:40:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab0AQMk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:40:27 -0500
Message-ID: <4B53052D.3020905@redhat.com>
Date: Sun, 17 Jan 2010 14:40:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Gleb Natapov <gleb@redhat.com>,
       Julia Lawall <julia@diku.dk>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: only allow one gsi per fd
References: <20100113165809.GA13334@redhat.com>
In-Reply-To: <20100113165809.GA13334@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 06:58 PM, Michael S. Tsirkin wrote:
> Looks like repeatedly binding same fd to multiple gsi's with irqfd can
> use up a ton of kernel memory for irqfd structures.
>
> A simple fix is to allow each fd to only trigger one gsi: triggering a
> srorm of interrupts in guest is likely useless anyway, and we can do it
> by binding a single gsi to many interrupts if we really want to.
>    

Applied and queued, thanks.

-- 
error compiling committee.c: too many arguments to function

