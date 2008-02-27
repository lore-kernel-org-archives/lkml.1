Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbYB0Vqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbYB0Vqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYB0Vqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:46:30 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:38165 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYB0Vq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:46:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eF3+64wdQGxDc99JVG60LfC+Yw4zDM6lggyQSlUkNrmy660TATkQyPJunUfmIjYMSJN355UEyIu7zKhE1iBb2Xt7t5iaT8CI8HplwlfaG1AuFSAGxncF/Vjiga+CBW+ICYtayPI28tsE6VByQfx2gJstzBnJu9wohitom/65Prk=
Message-ID: <ed10ee420802271346p6183f7e0y38b3f60dfb88d907@mail.gmail.com>
Date: Wed, 27 Feb 2008 13:46:28 -0800
From: "SL Baur" <steve@xemacs.org>
To: "Bernd Petrovitsch" <bernd@firmix.at>
Subject: Re: [PATCH] CodingStyle: multiple updates
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, ricknu-0@student.ltu.se,
       khc@pm.waw.pl, bhalevy.lists@gmail.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1204104420.17396.2.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204062430.47c488def40a4@portal.student.luth.se>
	 <20080226135444.f83a0536.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0802270033310.5714@axis700.grange>
	 <1204104420.17396.2.camel@tara.firmix.at>
X-Google-Sender-Auth: de064b20b38eeb8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/08, Bernd Petrovitsch <bernd@firmix.at> wrote:

> Unless I'm misunderstanding something completely: Add "indent-tabs-mode:
>  nil" in a "Local Variables:" section.

Yes, please don't ever do that.  At the very best it's an eyesore.
At the worst it's a typical Richard Stallman misfeature.  And pity the
poor programmer who happens to submit a patch containing such
magic when AKPM rains thunderbolts down from heaven to correct
the error.  (Andrew sustains an incoming patch load 2 orders of
magnitude higher than I ever had to and it drove me crazy, by all
means cater to his wishes).

-sb
