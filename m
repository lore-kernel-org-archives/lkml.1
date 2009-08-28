Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZH1ViM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZH1ViM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZH1ViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:38:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:44315 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZH1ViK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:38:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: Linux-2.6.31-rc8 inotify hangs samba clients
Date: Fri, 28 Aug 2009 14:37:45 -0700
Message-ID: <h79ina$p8b$1@ger.gmane.org>
References: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-182-64.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090828 Shredder/3.0b4pre
In-Reply-To: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 09:13 AM, Jeff Chua wrote:
>
>
> The first part of commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd hangs
> WinXP clients browsing Linux samba folders ... trying to add a
> terminating byte to name_len. Reverting this solves the problem.

As another data point, the same commit also prevents udev from creating
the /dev/vboxdrv device when the vboxdrv kernel module gets loaded.

Haven't tried Eric's patches yet, but I'm betting the problem will be
cured.  Thanks for the quick fix, Eric.

