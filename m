Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYHOSLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYHOSLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYHOSLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:11:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:5052 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbYHOSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=F3+9F8MQ+XY8vUT6eYImBTyJ1ufbdEhnYOUW4eUhcFV7/vv3wYtQ/8MevjewBQXSfz
         5YReVP91Ciuzg65xXZk/XZ+Ljh6H63GQXk7/uK32OFR1pakGPfrSG/soiWfdeRmA9/Vp
         giCzhxiYFO8fN/7kH5ZywX9ezG/yV+gyTFl5E=
Message-ID: <b6c5339f0808151111l4ba07c6esa7bb784a2f059bf2@mail.gmail.com>
Date: Fri, 15 Aug 2008 14:11:36 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jaco Kroon" <jaco@kroon.co.za>
Subject: Re: [ath5k-devel] ath5k on the Acer Aspire One
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "=?ISO-8859-1?Q?\"J.A._Magall=F3n\"?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48A5B093.5060102@kroon.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080815015131.39bb20ef@werewolf.home>
	 <200808150228.50473.elendil@planet.nl>
	 <20080815102151.4859f1ea@werewolf.home>
	 <b6c5339f0808150639h204234e0pbffcc09bbb43203@mail.gmail.com>
	 <48A5B093.5060102@kroon.co.za>
X-Google-Sender-Auth: a89d0a04242d0a06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 12:36 PM, Jaco Kroon <jaco@kroon.co.za> wrote:
>
> Is this using WPA-PSK or WPA-EAP?  I know my card works with PSK but I'm
> seeing similar results with EAP.  Haven't had time to properly analyze
> the problem yet and my AP is in the office for the weekend.

PSK.  I'll claim ignorance on EAP though I don't know why it wouldn't work.
The change I was thinking of in 2.6.26 was related to some packets not being
decrypted properly (http://marc.info/?l=linux-wireless&m=121064141521711).
There was also this one related to association failures around .27-rc1:
http://marc.info/?l=linux-wireless&m=121732394028001.

Let us know what you find out.
-- 
Bob Copeland %% www.bobcopeland.com
