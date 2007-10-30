Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbXJ3Dwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbXJ3Dwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXJ3Dwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:52:46 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:56461 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXJ3Dwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XOXHqp2HXAit9RQ2HEY9sksdkeQB0PX3uUmIdVUiDOttUZ9gfLCY+GPPKgBj97cxuGQzHfDhGFypFJv00+/A0prThkKR90Wwcwv+JWDAqMfvBrfH8wQHz4kKr6rbIE1LDnQnb9LilDTL83Qi8H+bxIA1g1b+fxVZg2DfOzoPyZU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: CIJOML <cijoml@volny.cz>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Mon, 29 Oct 2007 23:52:39 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
References: <200702212313.30359.cijoml@volny.cz> <d120d5000702220709j9c98delcdf9a45e298ac39f@mail.gmail.com> <200710292329.54895.cijoml@volny.cz>
In-Reply-To: <200710292329.54895.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710292352.39396.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Monday 29 October 2007, CIJOML wrote:
> Dne èt 22. února 2007 Dmitry Torokhov napsal(a):
>
> > Plus I
> > will export uniq in /proc/bus/input/devices and then yo can ask X guys
> > to allow matching on uniq as well.
> 
> Hi Dmitri,
> 
> I watched at 2.6.23 and this is still not done yet. Are there any patches 
> available to use???
> 

Input core does export uniq in /proc/bus/input/devices so now it is
up to individual drivers to populate this field in input_dev
structure.

-- 
Dmitry
