Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZLKHw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZLKHw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZLKHwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:52:23 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32308 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbZLKHwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:52:23 -0500
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
 gpioN for device names
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Greg KH <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>,
       "Nikula Jani.1 (EXT-Nixu/Helsinki)" <ext-jani.1.nikula@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20091211054614.GA23644@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de>
	 <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de>
	 <1260509771.12346.138.camel@localhost>  <20091211054614.GA23644@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 11 Dec 2009 09:51:34 +0200
Message-Id: <1260517894.12346.152.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Dec 2009 07:51:40.0330 (UTC) FILETIME=[C610E8A0:01CA7A36]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 06:46 +0100, ext Greg KH wrote:
> > And no, we do not have per-gpio struct device, so we cannot add a new
> > "name" attribute there. We need to either persuade you to accept our
> > solution or make you take closer look at gpoiolib subsystem and suggest
> > us the right way to go :-)
> 
> If you don't have a struct device, then what are you going to generate a
> symlink to?

Sorry, this piece of information was wrong.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

