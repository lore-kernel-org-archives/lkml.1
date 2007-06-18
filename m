Return-Path: <linux-kernel-owner+w=401wt.eu-S1762976AbXFRMU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762976AbXFRMU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 08:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXFRMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 08:20:19 -0400
Received: from mail4.kite.se ([212.214.165.225]:40546 "EHLO mail4.kite.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXFRMUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 08:20:18 -0400
Message-ID: <4676787F.30609@kite.se>
Date: Mon, 18 Jun 2007 14:20:15 +0200
From: Magnus Naeslund <mag@kite.se>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ARC-1260: No space left on device, when there is (or should be)
 free space left
References: <4676679E.5040901@kite.se> <Pine.LNX.4.64.0706180730320.14972@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706180730320.14972@localhost.localdomain>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>>
>> (Ok here I have 68% free space on our 5.5TB device)
> 
> $ df -i
> 

Duh, this was it!
What is the recommended method on how to increase the inode count on the filesystem (there is no need for online resize in this case)?
I have the resize_inode option set when looking at the tune2fs -l output.

Magnus
