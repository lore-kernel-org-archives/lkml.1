Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZASVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZASVqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZASVqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:46:39 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:61853 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZASVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jTCpMQQWa9WXewTh238/e4CIqj9+ImbocfGGUI8oPy/xWhOjywv2C6hQDjdG2AzRhm
         gJqnIl9OHVjNzk/lc2sVgdVq4ILcA6XxXhe7nreoKrOJmE0P0ceIYeXIcTbyatct0FJ4
         /nUz2srVPM78hFXoLOUIqyk0iMDfrkeRDowNI=
MIME-Version: 1.0
In-Reply-To: <20090119201115.GD31356@linux-os.sc.intel.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
	 <4974CC8B.1030403@zytor.com>
	 <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com>
	 <4974DD86.2090300@zytor.com>
	 <20090119201115.GD31356@linux-os.sc.intel.com>
Date: Mon, 19 Jan 2009 13:46:37 -0800
Message-ID: <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due 
	to dc1e35c
From: Avuton Olrich <avuton@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 12:11 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Avuton, Does your bios has an option which says limit the cpuid
> vector limit to '2' or something. Can you disable that option and
> re-check? It will typically be located under cpu configuration settings.

You're the winner of the prize. The culprit in my bios was:

Max CPUID Value Limit: Enabled

I disabled it and 2.6.28.1 boots fine now.

Thanks!
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
