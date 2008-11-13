Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYKMWLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYKMWLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYKMWLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:11:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:52063 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYKMWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lbC5jSvvlxrO80hTR+IfTT+vBpp9YOFcaWs3KDJ8+RUidzkFWxSxrY8lo19pFIbL4V
         +oVTDCctcNV6GHmhM1mTS39T7owv4ZIahWiW23aWNzmVa4lIt+jrP7dh5y2fPMe7M2aK
         8IQufbpDjY7OHbpVpeaMMe5qJh+6eQzWAGnSY=
Message-ID: <491CA5FB.7060000@gmail.com>
Date: Thu, 13 Nov 2008 23:11:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/1 v2] DRM: fix radeon suspend/resume oops
References: <491CA495.7010007@gmail.com> <1226614196-17019-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1226614196-17019-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, wrong patch, wrong destination.

On 11/13/2008 11:09 PM, Jiri Slaby wrote:
> me wrote:
>> As the accesses to the mmio member are not protected by anything, they
>> seem to be racy with the open/clsoe anyways, setting this down there
>> too.
> 
> On the second though it should be protected. Updated patch below...

