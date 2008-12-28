Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYL1IDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYL1IDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 03:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbYL1IDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 03:03:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35314 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYL1IDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 03:03:37 -0500
Date: Sun, 28 Dec 2008 09:03:30 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: clean up error handling
Message-ID: <20081228080330.GB1600@ucw.cz>
References: <20081218182108.GA13546@elf.ucw.cz> <494AA15B.2010000@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494AA15B.2010000@steeleye.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-12-18 14:15:39, Paul Clements wrote:
> Hi Pavel,
>
> hanks for the patch...
>
> Pavel Machek wrote:
>> Uses existing error_out: label instead of hardcoding error action.
>>
>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
>> @@ -475,8 +473,7 @@ static void nbd_handle_req(struct nbd_de
>>  	if (nbd_send_req(lo, req) != 0) {
>>  		printk(KERN_ERR "%s: Request send failed\n",
>>  				lo->disk->disk_name);
>> -		req->errors++;
>> -		nbd_end_request(req);
>> +		goto error_out;
>
> This one is not correct. We don't return immediately here.

Sorry about that. Will do next series shortly...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
