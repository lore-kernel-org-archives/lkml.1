Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752471AbYLRIM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYLRIM5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYLRIMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:12:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:65207 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYLRIMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:12:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fzkUcoAxy2bK7ZS3BanhImWAzRf+VoRDZ+4YDigWXFJnXS6Il0a/IF6V8ct4kB33e2
         IBsGR67T6qLUTwXvQnVB61U5t6YROp1eXYAx4umfa0hgNy32S/QYV8pPMLe4zkiokYLj
         0LhT81BrKjt5Ts5kRaRDGfs9lWIT+AHhdr/aQ=
Message-ID: <494A05F6.7040101@panasas.com>
Date: Thu, 18 Dec 2008 10:12:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, v4l <video4linux-list@redhat.com>,
        Laurent Pinchart <laurent.pinchart@skynet.be>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [BUG] cdev_put() race condition
References: <200812082156.26522.hverkuil@xs4all.nl> <200812171607.41713.hverkuil@xs4all.nl> <49492437.7020105@panasas.com> <200812171833.39735.hverkuil@xs4all.nl> <20081217180805.GG28946@ZenIV.linux.org.uk>
In-Reply-To: <20081217180805.GG28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Dec 17, 2008 at 06:33:38PM +0100, Hans Verkuil wrote:
>> On Wednesday 17 December 2008 17:09:27 Boaz Harrosh wrote:
>>> Hans Verkuil wrote:
>>>> On Wednesday 17 December 2008 15:52:38 Boaz Harrosh wrote:
>>>>> Hans Verkuil wrote:
>>>>>> On Wednesday 17 December 2008 00:30:39 Greg KH wrote:
>>>>>>> On Wed, Dec 17, 2008 at 12:23:41AM +0100, Hans Verkuil wrote:
>>>>>>>> On Tuesday 16 December 2008 22:21:50 Greg KH wrote:
>>>>>>>>> On Tue, Dec 16, 2008 at 10:00:51PM +0100, Hans Verkuil wrote:
>>>>>>>>>> On Tuesday 16 December 2008 21:22:48 Greg KH wrote:
>>>>>>>>>>> On Mon, Dec 08, 2008 at 09:56:26PM +0100, Hans Verkuil wrote:
>>>>>>>>>>>> Hi Greg,
> 
> [snip 400-odd lines, with ~30 lines of original contents]
> 
> Could the esteemed sir kindly consider trimming the fucking crap or taking
> that to alt.cascade?
> --

Sorry, I apologize for that. I was CCing someone new and felt I might need
to leave the context of the conversation. But you are right it was getting
out of hand.

Boaz
