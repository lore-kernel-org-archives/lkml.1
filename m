Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbYFMN3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbYFMN3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYFMN2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:28:52 -0400
Received: from mail44.messagelabs.com ([216.82.249.179]:23696 "EHLO
	mail44.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYFMN2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:28:52 -0400
X-VirusChecked: Checked
X-Env-Sender: mhanafi@csc.com
X-Msg-Ref: server-9.tower-44.messagelabs.com!1213363729!3246297!4
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [20.137.2.88]
In-Reply-To: <e2e108260806122245xb2fdd36teb2f265317370875@mail.gmail.com>
Subject: Re: Tracking all signals how to
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OFD42FC397.DC34893F-ON85257467.0049F05B-85257467.00499095@csc.com>
From: Mahmoud Hanafi <mhanafi@csc.com>
Date: Fri, 13 Jun 2008 09:27:39 -0400
X-MIMETrack: Serialize by Router on AMER-GW09/SRV/CSC(Release 8.0.1|February 07, 2008) at
 06/13/2008 09:31:43 AM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I have verified that it was the OOM killer. We always get lots of
messages in the conole log when the oom killer starts. This is a very odd
problem as there are no logs showing what is doing the killing.

May I can wrap the kill() systemcall?


Computer Sciences Corporation
Registered Office: 3170 Fairview Park Drive, Falls Church, Virginia 22042,
USA
Registered in Nevada, USA No: C-489-59

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

This is a PRIVATE message. If you are not the intended recipient, please
delete without copying and kindly advise us by e-mail of the mistake in
delivery.
NOTE: Regardless of content, this e-mail shall not operate to bind CSC to
any order or other contract unless pursuant to explicit written agreement
or government initiative expressly permitting the use of e-mail for such
purpose.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------




                                                                           
             "Bart Van Assche"                                             
             <bart.vanassche@g                                             
             mail.com>                                                  To 
                                       Mahmoud Hanafi/DEF/CSC@CSC          
             06/13/2008 01:45                                           cc 
             AM                        linux-kernel@vger.kernel.org        
                                                                   Subject 
                                       Re: Tracking all signals how to     
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           




On Thu, Jun 12, 2008 at 11:37 PM, Mahmoud Hanafi <mhanafi@csc.com> wrote:
> We have random nodes experience killing of most daemons( syslog, ssh,
> cron, etc). All these daemons report getting a sigkill or sigterm.
>
> My question.... Is there a way to log all signals and the originator
> pid/proc name.

Did you already have a look in the kernel messages to make sure it's
not an OOM problem ? I do not know of any Linux software that sends
random signals to random processes.

Bart.


