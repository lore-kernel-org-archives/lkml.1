Return-Path: <linux-kernel-owner+w=401wt.eu-S1767378AbXDEWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767378AbXDEWip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767387AbXDEWip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:38:45 -0400
Received: from dkny.pando.com ([67.99.55.163]:59928 "EHLO dkny.pando.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767381AbXDEWio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:38:44 -0400
X-Greylist: delayed 2055 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 18:38:44 EDT
Message-ID: <4615726B.4080800@pando.com>
Date: Thu, 05 Apr 2007 18:04:27 -0400
From: Yaar Schnitman <yaar@pando.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Yaar Schnitman <yaar@pando.com>
Subject: optimizing sendfile
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How can I control the size of the block requests the sendfile() syscall 
performs
against the disk?

I'm using sendfile (on a 2.6.18 kernel) to copy 1M file chunks into a 
socket. The
socket send buffer size is 2MB, and I verify that its empty before 
making the call.
Indeed, 1M chunk is being sent, but from iostat, I can tell that the 
average request
size is around 128KB. Are there any kernel configuration variables that 
could change that?

Help will be appreciated.

