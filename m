Return-Path: <linux-kernel-owner+w=401wt.eu-S1423065AbXCBNQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423065AbXCBNQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423069AbXCBNQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:16:07 -0500
Received: from staple.laurelnetworks.com ([63.94.127.68]:50879 "EHLO
	staple.laurelnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423065AbXCBNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:16:06 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 08:16:06 EST
Message-ID: <45E8220D.9040905@laurelnetworks.com>
Date: Fri, 02 Mar 2007 08:09:33 -0500
From: Mike Accetta <maccetta@laurelnetworks.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Someone please turn on the http protocol on git.kernel.org!
References: <7TYYU-5L8-11@gated-at.bofh.it> <7U2zx-392-13@gated-at.bofh.it>
In-Reply-To: <7U2zx-392-13@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Timur Tabi wrote:
>> I see we now have a dedicate machine for the git server.  That's 
>> great.  How about turning on the http protocol so that those of use 
>> behind a firewall can clone trees?
> 
>> I get this:
>>
>> $ git-clone http://git.kernel.org/pub/scm/git.git
>> Initialized empty Git repository in /temp/git/.git/
>> Cannot get remote repository information.
>> Perhaps git-update-server-info needs to be run there?
> 
> Don't use the git server for that, please.  Use 
> http://www.kernel.org/pub/scm/... instead.

Another unfortunate stuck behind a firewall here.  When I try this it chugs
along for a while seeming to work but eventually aborts:

% git clone http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linus
...
walk 0964ce24d091a1d3dc7f667e1b107ab77d4325e6
walk c264852726dde251a0c09ec22f61a9be8b0db68b
walk 69903d6500c73af8329a5fba7153b0d50748981c
walk b59a9504cb93db7fae31e60760725d48652a1fc3
error: Couldn't get http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/refs/tags/v2.6.11 for tags/v2.6.11
The requested URL returned error: 404
error: Could not interpret tags/v2.6.11 as something to pull
-- 
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
