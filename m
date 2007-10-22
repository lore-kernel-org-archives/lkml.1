Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbXJVJoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbXJVJoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXJVJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:43:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbXJVJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NiSEzWOVkEExGAEQ7wZsuHAjWMtM2TasubhmdRmPHOEYFhF/nKFKltjfyq5/IRO6rSIgqKa5z6MqjWhwVZ/jFWYP4vvrxZ0JrkwRv8pWIDB6zwUgkt+WziDpAp1QDvHoa1N+FhKr9ddo7YxZn8K2+S/iqZ/htWwsXsBxpZprYCE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: 100% iowait on one of cpus in current -git
Date: Mon, 22 Oct 2007 11:43:18 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710220822.52370.maximlevitsky@gmail.com> <20071022111152.12ca0425@localhost>
In-Reply-To: <20071022111152.12ca0425@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221143.18356.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 11:11:52 Paolo Ornati wrote:
> On Mon, 22 Oct 2007 08:22:52 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > I tried to bisect this, but eventually I run into other bugs that cause system to oops early.
> 
> You can pick a different revision to test with:
> 	git-reset --hard  "SHA1"
> 
> Choose one with "git-bisect visualize".
> 

Well, I know that, and I did try this a lot.

The problem is that between good and bad revisions there are few bugs that cause the system to oops early,
thus I can't tell whenever the 100% iowait bug is present or not.

Best regards,
	Maxim Levitsky
