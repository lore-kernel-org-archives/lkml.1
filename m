Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYIJMwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYIJMwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYIJMwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:52:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:35278 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIJMwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HCYIuUIFBvOe1Qlj/T6frozVs2cU/GolOrtXXb/+K15eeHY2bAYuu8ANNtLvg9q346
         nXVOWrhNlQ4wxMFp9+gvjzchDKhLpHKSrHKO4SlBgtZiATR6EDZPdlLSIYk5FlRdvnNY
         0w1ny+Dz2Gn+155MXB+7l6+L8MKxaOqihAFV8=
Date: Wed, 10 Sep 2008 08:52:28 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: mousedev: Emulate right and middle buttons
	for single-button touchpads
Message-ID: <20080910125228.GA25221@anvil.corenet.prv>
References: <48C0893C.6060901@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C0893C.6060901@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Sep 05, 2008 at 03:19:56AM +0200, Henrik Rydberg wrote:
> On most linux-based systems, the right and middle buttons are used
> extensively. On computers lacking either of those buttons, such as
> the Apple Macbooks, emulation is needed. This patch adds emulation
> of the missing buttons via two-fingers-and-click and three-fingers-
> and-click operations, which has recently become standard, both in
> MacOS and in the Xorg synaptics driver.
> 

The standard way of emulating right and middle button presses for
"button-deficient" devices is to use Macintosh emulation
(MAC_EMUMOUSEBTN) that works not only for touchpads but for regular mice
as well.

Overall I don't think we should enhance mousedev for scenarios where
proper solution is to install Synaptics X driver. This also goes for
your other patch improving tapping in mousedev.

-- 
Dmitry
