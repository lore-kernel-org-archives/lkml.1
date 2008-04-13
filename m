Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYDMVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYDMVcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYDMVb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:31:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:56115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYDMVb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SDArWp1AFX9R5x5dHCQp98UK05sm8MeCxuWMkwMUktL1EL6WjENPfs8Rv9dohO1SY8BiTKFHEcGlBJCB/gR4xo+DWARbxWbUTGckSwxqc6piVdb3dXUdqZf6yCFqbrtcrfBJwPnw/9+V0YczS4pLiu+OxTWB7h+NpjjbcBiLr6g=
From: Alexia Death <alexiadeath@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Date: Mon, 14 Apr 2008 00:32:21 +0300
User-Agent: KMail/1.9.9
References: <200804132326.07713.alexiadeath@gmail.com> <20080413214211.3730e977@core>
In-Reply-To: <20080413214211.3730e977@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140032.22110.alexiadeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008 23:42:11 Alan Cox wrote:
> > http://en.wikipedia.org/wiki/Secure_Digital_card#Compatibility_issues_wit
> >h_2_GB_and_larger_cards tells me that this is the result of a hack due to
> > the nature of 2GB cards.
> >
> > Are there any plans to make 2GB SD cards work? I doubt I'm the only one
> > with such 2GB SD cards(and a camera) and Id be royally screwed right
> > about now if I did not have my photobank and an option to use it as a
> > copy over point...
>
> Mounting it with -o loop ought to work around this if the problem is
> purely media block size. That is probably the right answer anyway but the
> solution ought to be managed more elegantly for the user.

It seems the issue is a bit more complicated. Tried it with -o loop. It did 
mount but the contents was binary garbage... Strangely different binary 
garbage at each mount...  

--
Best,
Alexia
